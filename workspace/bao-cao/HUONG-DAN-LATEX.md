# 📘 HƯỚNG DẪN LÀM VIỆC VỚI LATEX CHO KLTN

**Đề tài**: "NGHIÊN CỨU VÀ ỨNG DỤNG CHATBOT AI TRONG PHÁT TRIỂN WEBSITE MẠNG XÃ HỘI"

---

## I. ĐẶC THÙ CỦA ĐỀ TÀI

### 1.1 Điểm khác biệt

Đề tài này **KHÔNG** xây dựng website hoàn chỉnh như khóa luận truyền thống, mà tập trung vào:

✅ **Sản phẩm chính**: Các bộ **Agent Skill** (công cụ AI tự động hóa)
✅ **Giai đoạn**: Life-2 (Phân tích & Thiết kế)
✅ **Output thực tế**: Diagrams (Sequence, Flow, Class, Activity), Database Schema, UI Wireframe Specs
✅ **Giá trị**: Tạo tài liệu chuẩn để AI Code Agent (Life-3) hoặc Developer đọc và implement

### 1.2 Ý nghĩa

Thay vì **code thủ công**, đề tài xây dựng **"Knowledge Factory"** — hệ thống AI Skills tự động hóa việc:
- Phân tích yêu cầu → Tạo sơ đồ UML
- Thiết kế database schema → Sinh YAML contract
- Thiết kế UI components → Tạo wireframe specs

→ **Đầu ra**: Tài liệu thiết kế đầy đủ, chính xác, có traceability (nguồn trích dẫn rõ ràng)

---

## II. CẤU TRÚC CHƯƠNG 2 ĐỀ XUẤT

```
CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG AGENT SKILLS

2.1. Kiến trúc tổng thể hệ thống Agent Skills
     2.1.1. Mô hình Meta-Skill Framework
     2.1.2. Ba trụ cột (3 Pillars): Knowledge, Process, Guardrails
     2.1.3. Bảy vùng (7 Zones): Core, Knowledge, Scripts, Templates, Data, Loop, Assets
     2.1.4. Quy trình 5 bước xây dựng Skill

2.2. Bộ kỹ năng kiến trúc sư (Skill Architect)
     2.2.1. Vai trò và vị trí trong pipeline
     2.2.2. Quy trình Adaptive Workflow
     2.2.3. Cơ chế Self-Scoring và Quality Gates
     2.2.4. Zone Mapping Contract
     2.2.5. Sản phẩm đầu ra: design.md

2.3. Bộ kỹ năng phân tích luồng nghiệp vụ
     2.3.1. Sequence Design Analyst
            - Phân tích tương tác giữa objects
            - Quy trình 5 pha: Collect → Research → Design → Generate → Verify
            - Sản phẩm: Sequence Diagram (Mermaid)
     2.3.2. Flow Design Analyst
            - Sơ đồ luồng 3-lane Swimlane (User/System/DB)
            - Phân tích từ Use Case → Business Process Flow
            - Sản phẩm: Flowchart Diagram (Mermaid)
     2.3.3. Activity Diagram Analyst
            - Phân tích theo Clean Architecture (B-U-E)
            - Phát hiện Deadlocks và logic issues
            - Sản phẩm: Activity Diagram (Mermaid)

2.4. Bộ kỹ năng thiết kế cấu trúc dữ liệu (Class Diagram Analyst)
     2.4.1. Dual-format output strategy
            - Mermaid classDiagram (cho người đọc)
            - YAML Contract (cho AI Agent)
     2.4.2. Aggregate Root vs Embedded Document
     2.4.3. Source Citation mechanism (chống hallucination)
     2.4.4. Quy trình 6 phases với 3 Interaction Points
     2.4.5. Sản phẩm: class-mX.md + class-mX.yaml

2.5. Bộ kỹ năng phân tích kiến trúc giao diện (UI Architecture Analyst)
     2.5.1. Data-Component Binding
            - Schema field type → UI Component (shadcn)
            - Validation rules → Component props
     2.5.2. Screen Inventory và UI Contract
     2.5.3. Quy trình 5 phases: Context Discovery → Screen ID → Mapping → Synthesis → Output
     2.5.4. Sản phẩm: mX-ui-spec.md

2.6. Quy trình phối hợp và tích hợp
     2.6.1. Pipeline tổng thể: Architect → Planner → Builder
     2.6.2. Interaction Points và Quality Gates
     2.6.3. Traceability matrix (Use Case → Diagram → Schema → UI)
     2.6.4. Knowledge Factory model
```

---

## III. MẪU CODE LATEX CHO TỪNG PHẦN

### 3.1 Phần 2.1 — Kiến trúc tổng thể

```latex
\section{Kiến trúc tổng thể hệ thống Agent Skills}

Hệ thống Agent Skills được xây dựng dựa trên mô hình \textbf{Meta-Skill Framework},
bao gồm ba trụ cột chính và bảy vùng chức năng. Kiến trúc này đảm bảo tính nhất quán,
khả năng kiểm soát chất lượng và khả năng mở rộng của các bộ Agent Skill.

\subsection{Mô hình Meta-Skill Framework}

Meta-Skill Framework định nghĩa cách tiếp cận tổng thể để xây dựng một Agent Skill
có cấu trúc, logic rõ ràng và khả năng tự kiểm soát chất lượng. Mô hình này được
minh họa trong Hình \ref{fig:meta-skill-framework}.

% Hình minh họa (chuyển từ Mermaid diagram)
\begin{figure}[h]
\centering
\includegraphics[width=0.8\textwidth]{figures/meta-skill-framework}
\caption{Mô hình Meta-Skill Framework}
\label{fig:meta-skill-framework}
\end{figure}

\subsection{Ba trụ cột (3 Pillars)}

Kiến trúc Agent Skill được xây dựng trên ba trụ cột chính:

\begin{itemize}
    \item \textbf{Pillar 1 — Knowledge (Tri thức)}: Tập hợp các quy định, tiêu chuẩn kỹ thuật
    (UML, Schema, Design Patterns) cung cấp context cho AI Agent. Tri thức được tổ chức
    trong thư mục \texttt{knowledge/} và được nạp theo chiến lược Progressive Disclosure.

    \item \textbf{Pillar 2 — Process (Quy trình)}: Các bước thực thi được module hóa thành
    workflow rõ ràng, từ nhận diện đầu vào đến kiểm chứng đầu ra. Mỗi skill định nghĩa
    riêng quy trình phù hợp với domain của nó (ví dụ: 5-phase workflow, 6-phase workflow).

    \item \textbf{Pillar 3 — Guardrails (Kiểm soát)}: Các hàng rào bảo vệ chống lại hiện tượng
    "hallucination" của AI thông qua cơ chế Interaction Gates, Source Citation, và Self-Scoring.
\end{itemize}

\subsection{Bảy vùng chức năng (7 Zones)}

Mỗi Agent Skill được tổ chức thành 7 zones chuẩn như mô tả trong Bảng \ref{tab:7-zones}.

% Bảng 7 Zones
\begin{table}[h]
\centering
\caption{Bảng mô tả 7 Zones trong Agent Skill}
\label{tab:7-zones}
\begin{tabular}{|p{0.15\textwidth}|p{0.35\textwidth}|p{0.35\textwidth}|}
\hline
\textbf{Zone} & \textbf{Mục đích} & \textbf{Ví dụ nội dung} \\
\hline
Core (SKILL.md) & Linh hồn điều khiển — Persona, Workflow, Guardrails &
Persona: Senior Architect; 5-phase workflow; Interaction Points \\
\hline
knowledge/ & Tri thức chuẩn — Standards, Best practices &
UML rules, Design patterns, MongoDB patterns \\
\hline
scripts/ & Công cụ tự động hóa — Python, Bash, JavaScript &
analyzer.py, validator.py, generator.py \\
\hline
templates/ & Mẫu đầu ra — Code stubs, Diagram templates &
sequence.mmd, class.mmd, design.md.template \\
\hline
data/ & Cấu hình và dữ liệu cứng — Config YAML, JSON schema &
config.yaml, allowed-types.json \\
\hline
loop/ & Kiểm soát chất lượng — Checklist, Test cases &
checklist.md, phase-verify.md, test-cases/ \\
\hline
assets/ & Tài nguyên tĩnh — Icons, Fonts, Images &
icons/, fonts/, images/ \\
\hline
\end{tabular}
\end{table}

\subsection{Quy trình 5 bước xây dựng Skill}

Quy trình xây dựng một Agent Skill tuân theo 5 bước chuẩn (Hình \ref{fig:5-step-workflow}):

\begin{enumerate}
    \item \textbf{Khảo sát (Research)}: Xác định Pain Point, Input/Output, Tools cần dùng
    \item \textbf{Thiết kế (Design)}: Xây dựng logic workflow, Interaction Points, Output format
    \item \textbf{Xây dựng (Build)}: Viết SKILL.md, tạo templates, scripts, knowledge files
    \item \textbf{Kiểm định (Verify)}: Chạy Test Cases, Verify Checklist, Rollback nếu fail
    \item \textbf{Bảo trì (Maintenance)}: Feedback Loop, Version Control, cập nhật khi môi trường thay đổi
\end{enumerate}
```

### 3.2 Phần 2.2 — Skill Architect

```latex
\section{Bộ kỹ năng kiến trúc sư (Skill Architect)}

Skill Architect là meta-skill trung tâm, chịu trách nhiệm thiết kế cấu trúc cho các
Agent Skills khác. Đây là điểm khởi đầu của toàn bộ Skill Suite trong pipeline
\texttt{Architect → Planner → Builder}.

\subsection{Vai trò và vị trí trong pipeline}

Skill Architect đóng vai trò như một "kiến trúc sư trưởng", nhận yêu cầu từ người dùng
và tạo ra bản thiết kế chi tiết (\texttt{design.md}) cho skill mới. Vị trí của nó
trong pipeline được minh họa trong Hình \ref{fig:skill-suite-pipeline}.

% Hình minh họa pipeline
\begin{figure}[h]
\centering
\includegraphics[width=0.9\textwidth]{figures/skill-suite-pipeline}
\caption{Pipeline Architect → Planner → Builder}
\label{fig:skill-suite-pipeline}
\end{figure}

\subsection{Quy trình Adaptive Workflow}

Skill Architect sử dụng quy trình Adaptive Workflow, tự động phân loại độ phức tạp
của yêu cầu (Simple / Medium / Complex) và chọn workflow phù hợp:

\begin{itemize}
    \item \textbf{Simple}: COLLECT (rút gọn) → DESIGN (merge Analyze + Design)
    \item \textbf{Medium}: COLLECT → ANALYZE → DESIGN
    \item \textbf{Complex}: COLLECT → ANALYZE → ARCH-REVIEW → DESIGN
\end{itemize}

Quy trình này được minh họa trong Hình \ref{fig:adaptive-workflow}.

\subsection{Cơ chế Self-Scoring và Quality Gates}

Skill Architect tích hợp cơ chế tự đánh giá (Self-Scoring) để đảm bảo chất lượng
thiết kế trước khi chuyển sang giai đoạn thực thi. Các tiêu chí đánh giá bao gồm:

\begin{table}[h]
\centering
\caption{Rubric tự đánh giá Skill Architect}
\label{tab:self-scoring}
\begin{tabular}{|l|p{0.6\textwidth}|c|}
\hline
\textbf{Section} & \textbf{Tiêu chí} & \textbf{Điểm tối thiểu} \\
\hline
§1 Problem & Pain Point rõ ràng, User xác định, Output cụ thể & 3/5 \\
§2 Capability & 3 Pillars đầy đủ, Process có workflow diagram & 3/5 \\
§3 Zone Mapping & Tên file cụ thể (regex compliant), không placeholder & 4/5 \\
§5 Execution Flow & Có ≥2 diagrams (sequence/flowchart) & 3/5 \\
§8 Risks & Có ≥5 risks kèm mitigation cụ thể & 3/5 \\
\hline
\end{tabular}
\end{table}

Nếu bất kỳ section nào có điểm < 3/5, AI phải re-work section đó trước khi deliver.

\subsection{Zone Mapping Contract}

§3 Zone Mapping trong \texttt{design.md} là contract bắt buộc giữa Architect và Planner.
Nó quy định rõ ràng các file cần tạo, nội dung từng zone, và trạng thái bắt buộc/tùy chọn.

Ví dụ Zone Mapping cho Skill Architect:

\begin{table}[h]
\centering
\caption{Zone Mapping Contract của Skill Architect}
\label{tab:zone-mapping}
\begin{tabular}{|l|p{0.35\textwidth}|p{0.25\textwidth}|c|}
\hline
\textbf{Zone} & \textbf{Files} & \textbf{Nội dung} & \textbf{Bắt buộc?} \\
\hline
Core & SKILL.md & Persona, Workflow, Guardrails & ✅ \\
Knowledge & complexity-matrix.md & Bảng phân loại Simple/Medium/Complex & ✅ \\
Knowledge & zone-contract-spec.md & Schema §3, regex validation & ✅ \\
Scripts & init\_context.py & Khởi tạo .skill-context/ & ✅ \\
Templates & design.md.template & 10-section template & ✅ \\
Loop & design-checklist.md & Quality gate tổng & ✅ \\
Loop & phase-verify.md & Per-phase checklist & ✅ \\
\hline
\end{tabular}
\end{table}

\subsection{Sản phẩm đầu ra: design.md}

Sản phẩm chính của Skill Architect là file \texttt{design.md} theo format chuẩn 10 sections:

\begin{enumerate}
    \item Problem Statement
    \item Capability Map (3 Pillars)
    \item Zone Mapping (Contract)
    \item Folder Structure (Mermaid mindmap)
    \item Execution Flow (Diagrams)
    \item Interaction Points
    \item Progressive Disclosure Plan
    \item Risks \& Blind Spots
    \item Open Questions
    \item Metadata
\end{enumerate}

File \texttt{design.md} này là đầu vào chính cho \textbf{Skill Planner} ở giai đoạn tiếp theo.
```

### 3.3 Phần 2.4 — Class Diagram Analyst

```latex
\section{Bộ kỹ năng thiết kế cấu trúc dữ liệu (Class Diagram Analyst)}

Class Diagram Analyst (Skill 2.5) đảm nhiệm việc chuyển đổi từ ER Diagram và quy trình
nghiệp vụ sang Class Diagram với định dạng dual-format (Mermaid + YAML Contract).

\subsection{Dual-format output strategy}

Skill tạo ra hai loại output cho hai đối tượng khác nhau:

\begin{itemize}
    \item \textbf{Mermaid classDiagram} (\texttt{class-mX.md}): Dạng trực quan cho
    con người review, bao gồm sơ đồ lớp và bảng Traceability (field → source mapping).

    \item \textbf{YAML Contract} (\texttt{class-mX.yaml}): Dạng machine-readable cho
    AI Agent đọc (đặc biệt là \texttt{schema-design-analyst} ở giai đoạn tiếp theo).
    File này có header LOCKED để tránh chỉnh sửa thủ công.
\end{itemize}

\subsection{Aggregate Root vs Embedded Document}

Một trong những quyết định quan trọng là phân loại entity thành Aggregate Root
(collection độc lập) hoặc Embedded Document (nhúng trong parent). Decision tree
được mô tả trong Hình \ref{fig:aggregate-decision}.

\begin{figure}[h]
\centering
\includegraphics[width=0.85\textwidth]{figures/aggregate-decision-tree}
\caption{Decision Tree: Aggregate Root vs Embedded}
\label{fig:aggregate-decision}
\end{figure}

Quy tắc quyết định:
\begin{enumerate}
    \item Nếu nhiều collection khác FK trỏ vào → \textbf{Aggregate Root}
    \item Nếu entity có timestamps riêng → \textbf{Aggregate Root}
    \item Nếu query entity độc lập → \textbf{Aggregate Root}
    \item Nếu size có thể vượt giới hạn (16MB MongoDB) → \textbf{Aggregate Root}
    \item Ngược lại → \textbf{Embedded Document}
\end{enumerate}

\subsection{Source Citation mechanism}

Để chống hallucination, mọi field trong Class Diagram PHẢI có source citation rõ ràng.
Ví dụ trong YAML Contract:

\begin{verbatim}
fields:
  - name: "email"
    type: "email"
    required: true
    unique: true
    source: "er-diagram.md#L169"
  - name: "bio"
    type: "text"
    source: "activity-diagrams/m1-a1-registration.md#L45"
\end{verbatim}

Guardrail bắt buộc: Field không có source → BLOCK, không ghi file. Field có source
từ file context (không có trong ER) → Mark \texttt{[FROM\_CONTEXT]}.

\subsection{Quy trình 6 phases với 3 Interaction Points}

Skill thực thi theo 6 phases với 3 Interaction Points bắt buộc (Hình \ref{fig:class-6-phase}):

\begin{enumerate}
    \item \textbf{Phase A — Extract Entities}: Đọc \texttt{er-diagram.md}, lấy entity + fields
    \item \textbf{Phase B — Cross-Reference}: Grep \texttt{activity-diagrams/} tìm Hooks/Behavior
    \item \textbf{Phase C — Classify}: Quyết định Root/Embed theo decision tree
    \item \textbf{[IP1] Confirm Entity List}: CHỜ user xác nhận danh sách entities
    \item \textbf{Phase D — Generate Markdown}: Sinh \texttt{class-mX.md}
    \item \textbf{[IP2] Review Markdown}: CHỜ user approve file .md
    \item \textbf{Phase E — Generate YAML}: Chuyển .md → .yaml contract
    \item \textbf{Phase F — Self-Validate}: Chạy \texttt{validate\_contract.py}
    \item \textbf{[IP3] Report Result}: Báo cáo validation pass/fail
\end{enumerate}

\subsection{Sản phẩm đầu ra}

Mỗi module tạo ra 2 files:

\begin{itemize}
    \item \texttt{Docs/life-2/diagrams/class-diagrams/m1-auth-profile/class-m1.md}
    \item \texttt{Docs/life-2/diagrams/class-diagrams/m1-auth-profile/class-m1.yaml}
\end{itemize}

File YAML này là input chính cho \textbf{schema-design-analyst} (Skill 2.6).
```

---

## IV. WORKFLOW LÀM VIỆC

### 4.1 Quy trình biên soạn Chương 2

```
Bước 1: Chuẩn bị nguồn
├─ Đọc file .skill-context/*/design.md của các skill chính:
│  ├─ skill-architect/design.md
│  ├─ sequence-design-analyst/design.md
│  ├─ flow-design-analyst/design.md
│  ├─ class-diagram-analyst/design.md
│  └─ ui-architecture-analyst/design.md
└─ Đọc workspace/architect.md (tài liệu framework tổng quát)

Bước 2: Trích xuất nội dung chính
├─ §1 Problem Statement → Giới thiệu vai trò skill
├─ §2 Capability Map → Mô tả 3 Pillars
├─ §3 Zone Mapping → Bảng cấu trúc zones
├─ §4 Folder Structure → Sơ đồ Mermaid mindmap
├─ §5 Execution Flow → Sơ đồ sequence/flowchart
└─ §8 Risks → Bảng rủi ro và mitigation

Bước 3: Chuyển đổi sang LaTeX
├─ Markdown table → LaTeX tabular
├─ Mermaid diagram → Export PNG/PDF → \includegraphics
├─ YAML/JSON code block → \begin{verbatim}
└─ Lists → \begin{itemize} hoặc \begin{enumerate}

Bước 4: Tích hợp vào KLTN-template.tex
├─ Thay thế phần 2.1-2.6 trong template
├─ Thêm \label{} cho cross-reference
├─ Thêm \ref{} khi tham chiếu hình/bảng
└─ Cập nhật \listoffigures, \listoftables

Bước 5: Compile và kiểm tra
├─ xelatex KLTN-template.tex (lần 1)
├─ xelatex KLTN-template.tex (lần 2 — update refs)
├─ Kiểm tra lỗi compile
└─ Verify output PDF
```

### 4.2 Chuyển đổi Mermaid → Hình ảnh

**Option 1**: Sử dụng Mermaid CLI (khuyến nghị)

```bash
# Install mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Convert file .mmd sang PNG
mmdc -i diagram.mmd -o diagram.png -w 1200 -H 800

# Hoặc PDF (chất lượng cao hơn)
mmdc -i diagram.mmd -o diagram.pdf -w 1200 -H 800
```

**Option 2**: Sử dụng Online Editor

1. Mở https://mermaid.live/
2. Paste code Mermaid
3. Export PNG/SVG/PDF
4. Lưu vào `bao-cao/figures/`

**Option 3**: LaTeX package `mermaid` (experimental)

```latex
\usepackage{mermaid}

\begin{mermaid}
graph TD
  A[Start] --> B[Process]
  B --> C[End]
\end{mermaid}
```

---

## V. CHECKLIST HOÀN THIỆN CHƯƠNG 2

### 5.1 Nội dung

- [ ] §2.1 đã giới thiệu đầy đủ Meta-Skill Framework?
- [ ] §2.1 đã có sơ đồ minh họa 3 Pillars & 7 Zones?
- [ ] §2.2-2.5 đã trích xuất đủ nội dung từ design.md?
- [ ] Mỗi skill đã có: vai trò, quy trình, sản phẩm đầu ra?
- [ ] §2.6 đã mô tả pipeline và traceability?
- [ ] Tất cả hình ảnh đã có caption và \label{}?
- [ ] Tất cả bảng biểu đã có caption và \label{}?

### 5.2 Định dạng LaTeX

- [ ] Font Times New Roman 14pt?
- [ ] Lề trái 3.5cm, phải/trên/dưới 2cm?
- [ ] Giãn dòng 1.5 lines (\onehalfspacing)?
- [ ] Tên chương IN HOA, đậm, căn giữa?
- [ ] Mục cấp 1 (2.1) đậm, căn trái?
- [ ] Mục cấp 2 (2.1.1) đậm, nghiêng?
- [ ] Đánh số trang tự nhiên (1, 2, 3...)?

### 5.3 Hình ảnh và Bảng

- [ ] Tất cả Mermaid diagram đã export PNG/PDF?
- [ ] File hình đã lưu trong `bao-cao/figures/`?
- [ ] Đã cập nhật \listoffigures trong template?
- [ ] Đã cập nhật \listoftables trong template?
- [ ] Cross-reference (\ref{}) hoạt động đúng?

---

## VI. TỰ ĐỘNG HÓA VỚI SKILL (TÙY CHỌN)

Nếu cần tự động hóa quá trình trích xuất từ `.skill-context/` → LaTeX,
có thể tạo **latex-report-specialist skill** với workflow:

```
Phase 1: Scan .skill-context/
├─ List tất cả design.md files
└─ Parse content theo sections §1-§10

Phase 2: Extract content
├─ §1 Problem → \subsection{Vai trò}
├─ §2 Capability → \subsection{3 Pillars}
├─ §3 Zone Mapping → \begin{table}
├─ §4 Folder → Export Mermaid → PNG
└─ §5 Execution → Export Mermaid → PNG

Phase 3: Generate LaTeX
├─ Apply template từ templates/chapter-2.tex.template
├─ Insert extracted content
└─ Generate KLTN-chuong-2-AUTO.tex

Phase 4: Compile
├─ xelatex KLTN-chuong-2-AUTO.tex
└─ Output: KLTN-chuong-2-AUTO.pdf
```

**Skill này có thể được tạo nếu cần** — hiện tại hướng dẫn thủ công đã đủ để bắt đầu.

---

## VII. NOTES QUAN TRỌNG

1. **Không tự bịa nội dung**: Mọi nội dung Chương 2 phải lấy từ `.skill-context/` hoặc `workspace/architect.md`
2. **Giữ nguyên thuật ngữ kỹ thuật**: Aggregate Root, Guardrails, Interaction Points, etc.
3. **Trích dẫn nguồn**: Footnote hoặc caption ghi rõ "Nguồn: design.md của Skill X"
4. **Sơ đồ Mermaid**: Ưu tiên export PNG/PDF độ phân giải cao (1200x800 trở lên)
5. **Code snippets**: Dùng \begin{verbatim} hoặc \begin{lstlisting} với syntax highlighting

---

**Tác giả**: Claude Code Agent
**Ngày tạo**: 2026-02-22
**Phiên bản**: 1.0
