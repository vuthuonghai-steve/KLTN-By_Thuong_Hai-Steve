import React, { InputHTMLAttributes, ButtonHTMLAttributes, TextareaHTMLAttributes } from 'react';

// --- BUTTONS ---
interface NeoButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
}

export const NeoButton: React.FC<NeoButtonProps> = ({ 
  children, 
  variant = 'primary', 
  size = 'md', 
  fullWidth = false,
  className = '',
  ...props 
}) => {
  const baseStyles = "font-bold border-2 border-black transition-all active:translate-x-[2px] active:translate-y-[2px] active:shadow-none uppercase tracking-wide flex items-center justify-center gap-2";
  
  const variants = {
    primary: "bg-neo-primary text-black shadow-hard hover:bg-orange-600 hover:shadow-hard-lg",
    secondary: "bg-white text-black shadow-hard hover:bg-gray-50",
    ghost: "bg-transparent border-black text-black shadow-none hover:bg-neo-primary/20",
    danger: "bg-red-500 text-white shadow-hard hover:bg-red-600"
  };

  const sizes = {
    sm: "px-3 py-1 text-xs",
    md: "px-6 py-3 text-sm",
    lg: "px-8 py-4 text-base",
  };

  const width = fullWidth ? "w-full" : "";

  return (
    <button 
      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${width} ${className}`} 
      {...props}
    >
      {children}
    </button>
  );
};

// --- INPUTS ---
interface NeoInputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  helperText?: string;
}

export const NeoInput: React.FC<NeoInputProps> = ({ label, helperText, className = '', ...props }) => {
  return (
    <div className="w-full">
      {label && <label className="block text-sm font-bold uppercase mb-2 text-black">{label}</label>}
      <input 
        className={`w-full bg-white border-2 border-black px-4 py-3 font-mono text-sm focus:outline-none focus:shadow-hard transition-shadow placeholder:text-gray-400 ${className}`}
        {...props}
      />
      {helperText && <p className="mt-1 text-xs font-mono text-gray-600">{helperText}</p>}
    </div>
  );
};

// --- TEXTAREA ---
interface NeoTextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
}

export const NeoTextarea: React.FC<NeoTextareaProps> = ({ label, className = '', ...props }) => {
  return (
    <div className="w-full">
      {label && <label className="block text-sm font-bold uppercase mb-2 text-black">{label}</label>}
      <textarea 
        className={`w-full bg-white border-2 border-black px-4 py-3 font-mono text-sm focus:outline-none focus:shadow-hard transition-shadow resize-none ${className}`}
        {...props}
      />
    </div>
  );
};

// --- CARD ---
export const NeoCard: React.FC<{ children: React.ReactNode; className?: string; noPadding?: boolean }> = ({ children, className = '', noPadding = false }) => {
  return (
    <div className={`bg-white border-2 border-black shadow-hard ${noPadding ? '' : 'p-6'} ${className}`}>
      {children}
    </div>
  );
};

// --- BADGE ---
export const NeoBadge: React.FC<{ children: React.ReactNode; color?: string }> = ({ children, color = 'bg-neo-primary' }) => {
  return (
    <span className={`${color} border-2 border-black px-2 py-1 text-xs font-bold shadow-hard-sm inline-flex items-center`}>
      {children}
    </span>
  );
};

// --- AVATAR ---
export const NeoAvatar: React.FC<{ src: string; alt: string; size?: 'sm' | 'md' | 'lg' | 'xl'; className?: string }> = ({ src, alt, size = 'md', className = '' }) => {
  const sizes = {
    sm: "w-8 h-8",
    md: "w-12 h-12",
    lg: "w-20 h-20",
    xl: "w-32 h-32"
  };
  return (
    <div className={`${sizes[size]} rounded-full border-2 border-black overflow-hidden bg-gray-200 shrink-0 ${className}`}>
      <img src={src} alt={alt} className="w-full h-full object-cover" />
    </div>
  );
};
