#!/usr/bin/env python3
"""
analyze-screen.py - Phân tích Screen component để extract fields đang được sử dụng

Usage:
    python analyze-screen.py <file_path>
    python analyze-screen.py src/screens/Store/StoreOrdersScreen/hooks/useStoreOrdersData.ts

Description:
    Script này quét file TypeScript/TSX và detect các patterns truy cập property:
    - Dot notation: order.code, order.status
    - Optional chaining: order?.deliveryAddress?.names
    - Destructuring: const { code, status } = order
    - Array item access: items.map(item => item.product.name)

Output:
    Danh sách fields được nhóm theo nguồn (root, nested, array items)

Author: AI Agent (api-from-ui skill)
Version: 1.0.0
"""

import re
import sys
import os
from collections import defaultdict
from typing import List, Dict, Set, Any


def read_file(file_path: str) -> str:
    """Đọc nội dung file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        print(f"❌ Error: File not found: {file_path}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        sys.exit(1)


def extract_dot_notation(content: str) -> Set[str]:
    """
    Detect dot notation property access.
    Examples: order.code, order.status, data.orders
    """
    # Pattern: word.word (có thể lặp nhiều lần)
    # Loại bỏ các patterns không phải property access (như console.log)
    pattern = r'\b([a-z][a-zA-Z0-9]*(?:\.[a-zA-Z][a-zA-Z0-9]*)+)\b'
    
    matches = re.findall(pattern, content)
    
    # Filter out common non-data patterns
    exclude_prefixes = [
        'console.', 'Math.', 'Object.', 'Array.', 'String.', 'Number.',
        'Date.', 'JSON.', 'Promise.', 'Error.', 'window.', 'document.',
        'React.', 'process.', 'module.', 'export.', 'import.',
        'ToastService.', 'ApiService.', 'LocalStorageService.',
    ]
    
    filtered = set()
    for match in matches:
        if not any(match.startswith(prefix) for prefix in exclude_prefixes):
            # Loại bỏ function calls (kết thúc không có parentheses là OK)
            if not re.search(r'\(\s*$', match):
                filtered.add(match)
    
    return filtered


def extract_optional_chaining(content: str) -> Set[str]:
    """
    Detect optional chaining property access.
    Examples: order?.code, order?.deliveryAddress?.names
    """
    # Pattern: word?.word (có thể lặp)
    pattern = r'\b([a-z][a-zA-Z0-9]*(?:\?\.[a-zA-Z][a-zA-Z0-9]*)+)\b'
    
    matches = re.findall(pattern, content)
    
    # Convert ?. to . for consistency
    normalized = set()
    for match in matches:
        normalized.add(match.replace('?.', '.'))
    
    return normalized


def extract_destructuring(content: str) -> Dict[str, List[str]]:
    """
    Detect destructuring patterns.
    Examples: 
        const { code, status } = order
        const { names, phoneNumbers } = deliveryAddress
    """
    # Pattern: const/let/var { fields } = source
    pattern = r'(?:const|let|var)\s*\{\s*([^}]+)\s*\}\s*=\s*([a-zA-Z][a-zA-Z0-9]*)'
    
    result: Dict[str, List[str]] = {}
    matches = re.findall(pattern, content)
    
    for match in matches:
        fields_str: str = str(match[0])
        source: str = str(match[1])
        # Parse fields, handling aliases like { name: aliasName }
        fields: List[str] = []
        for field in fields_str.split(','):
            field = field.strip()
            if ':' in field:
                # Handle alias: { originalName: aliasName }
                original = field.split(':')[0].strip()
                fields.append(original)
            elif field and not field.startswith('...'):
                fields.append(field)
        
        if source not in result:
            result[source] = []
        result[source].extend(fields)  # type: ignore
    
    return result




def extract_array_access(content: str) -> Set[str]:
    """
    Detect array item access patterns.
    Examples:
        items.map(item => item.product.name)
        orders.forEach(order => order.code)
        data.filter(d => d.status === 'active')
    """
    # Pattern: array.map/forEach/filter(item => item.property)
    pattern = r'\.(?:map|forEach|filter|find|some|every|reduce)\s*\(\s*\(?([a-zA-Z][a-zA-Z0-9]*)\)?\s*=>'
    
    # Find all callback variable names
    callback_vars = set(re.findall(pattern, content))
    
    # Find property access on these variables
    results = set()
    for var in callback_vars:
        # Find all property access on this variable
        var_pattern = rf'\b{var}(?:\?)?\.([a-zA-Z][a-zA-Z0-9]*(?:(?:\?)?\.([a-zA-Z][a-zA-Z0-9]*))*)'
        matches = re.findall(var_pattern, content)
        
        for match in matches:
            if isinstance(match, tuple):
                # Flatten tuple and filter empty
                path = '.'.join(filter(None, match))
            else:
                path = match
            
            if path:
                results.add(f"{var}[].{path}")
    
    return results


def extract_bracket_access(content: str) -> Set[str]:
    """
    Detect bracket notation access.
    Examples: order['code'], data[0].name
    """
    # Pattern: variable['property'] or variable["property"]
    pattern = r'\b([a-zA-Z][a-zA-Z0-9]*)\[[\'"]([a-zA-Z][a-zA-Z0-9]*)[\'\"]\]'
    
    matches = re.findall(pattern, content)
    
    results = set()
    for var, prop in matches:
        results.add(f"{var}.{prop}")
    
    return results


def categorize_fields(fields: Set[str]) -> Dict[str, Set[str]]:
    """
    Categorize fields by their source object.
    """
    categories = defaultdict(set)
    
    for field in fields:
        parts = field.replace('?.', '.').split('.')
        
        if len(parts) == 1:
            categories['root'].add(field)
        elif len(parts) == 2:
            source = parts[0]
            categories[f'nested ({source})'].add(field)
        else:
            source = parts[0]
            categories[f'deep nested ({source})'].add(field)
    
    return dict(categories)


def analyze_file(file_path: str) -> Dict[str, Any]:
    """
    Main analysis function.
    """
    content = read_file(file_path)
    
    # Extract all patterns
    dot_notation = extract_dot_notation(content)
    optional_chaining = extract_optional_chaining(content)
    destructuring = extract_destructuring(content)
    array_access = extract_array_access(content)
    bracket_access = extract_bracket_access(content)
    
    # Combine all fields
    all_fields = set()
    all_fields.update(dot_notation)
    all_fields.update(optional_chaining)
    all_fields.update(bracket_access)
    
    # Add destructuring fields
    for source, fields in destructuring.items():
        for field in fields:
            all_fields.add(f"{source}.{field}")
    
    return {
        'file': file_path,
        'dot_notation': dot_notation,
        'optional_chaining': optional_chaining,
        'destructuring': destructuring,
        'array_access': array_access,
        'bracket_access': bracket_access,
        'all_fields': all_fields,
        'categorized': categorize_fields(all_fields),
    }


def print_results(results: Dict[str, Any]) -> None:
    """
    Print analysis results in a readable format.
    """
    print("\n" + "=" * 60)
    print(f"📁 File: {results['file']}")
    print("=" * 60)
    
    print("\n📊 SUMMARY")
    print("-" * 40)
    print(f"Total unique fields detected: {len(results['all_fields'])}")
    
    print("\n🔍 FIELDS BY CATEGORY")
    print("-" * 40)
    
    for category, fields in sorted(results['categorized'].items()):
        print(f"\n{category.upper()}:")
        for field in sorted(fields):
            print(f"  • {field}")
    
    if results['array_access']:
        print("\n📋 ARRAY ITEM ACCESS:")
        for field in sorted(results['array_access']):
            print(f"  • {field}")
    
    if results['destructuring']:
        print("\n📦 DESTRUCTURING PATTERNS:")
        for source, fields in results['destructuring'].items():
            print(f"  {source}: {{ {', '.join(fields)} }}")
    
    print("\n" + "=" * 60)
    print("💡 TIP: Review these fields to determine which ones are needed in your DTO")
    print("=" * 60)


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print("Usage: python analyze-screen.py <file_path>")
        print("\nExample:")
        print("  python analyze-screen.py src/screens/Store/StoreOrdersScreen/hooks/useStoreOrdersData.ts")
        sys.exit(1)
    
    file_path = sys.argv[1]
    
    if not os.path.exists(file_path):
        print(f"❌ Error: File not found: {file_path}")
        sys.exit(1)
    
    print(f"🔍 Analyzing: {file_path}")
    
    results = analyze_file(file_path)
    print_results(results)


if __name__ == '__main__':
    main()
