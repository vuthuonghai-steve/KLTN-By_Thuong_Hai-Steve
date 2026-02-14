# **BÁO CÁO CHIẾN LƯỢC TOÀN DIỆN: KIẾN TRÚC KỸ NĂNG AGENT (AGENT SKILL), CƠ CHẾ KIỂM SOÁT CHẤT LƯỢNG VÀ TRIỂN KHAI TÀI NGUYÊN KỸ THUẬT TIÊU CHUẨN (2026)**

## **TỔNG QUAN ĐIỀU HÀNH: BỐI CẢNH VÀ SỰ CẤP THIẾT CỦA CẤU TRÚC HÓA**

Sự phát triển của công nghệ trí tuệ nhân tạo (AI) trong lĩnh vực phát triển phần mềm đã trải qua những bước chuyển mình mạnh mẽ từ giai đoạn thử nghiệm sơ khai đến việc ứng dụng đại trà trong môi trường doanh nghiệp. Bước sang năm 2026, chúng ta đang chứng kiến sự thoái trào của các phương pháp tiếp cận ngẫu hứng (thường được gọi là "Vibe Coding") và sự trỗi dậy mạnh mẽ của kỷ nguyên "Agentic Coding" – nơi các tác nhân AI (AI Agents) không chỉ đóng vai trò hỗ trợ mà còn là những thực thể bán tự chủ trong quy trình sản xuất phần mềm.1 Trong bối cảnh đó, việc thiết lập một khung kiến trúc chuẩn mực cho "Kỹ năng Agent" (Agent Skills) trở thành yêu cầu sống còn để đảm bảo tính nhất quán, độ tin cậy và khả năng kiểm soát của hệ thống.

Báo cáo này được xây dựng nhằm cung cấp một cái nhìn sâu sắc, toàn diện và mang tính kỹ thuật cao về cấu trúc, phương pháp luận và quy trình xây dựng các bộ Agent Skill. Dựa trên việc tổng hợp và phân tích dữ liệu từ các tài liệu kiến trúc nội bộ (architect.md, design.md, todo.md) cùng các xu hướng công nghệ mới nhất từ các chuyên gia đầu ngành 2, báo cáo sẽ giải mã chi tiết mô hình "7 Zones", quy trình "Master Skill Suite", và đặc biệt là cơ chế "Gatekeeper" (Người gác cổng) giúp loại bỏ các rủi ro về ảo giác (hallucination) và sai lệch quy trình. Bên cạnh phần phân tích lý thuyết, báo cáo cũng sẽ đáp ứng trực tiếp yêu cầu về việc khởi tạo nội dung chi tiết cho hai tài liệu cốt lõi: resources/build-guidelines.md và resources/validation-logic.md, đóng vai trò là nền tảng kỹ thuật cho việc tự động hóa quy trình kiểm soát chất lượng.

## ---

**PHẦN 1: SỰ TIẾN HÓA CỦA HỆ SINH THÁI AGENT VÀ VAI TRÒ CỦA KỸ NĂNG (SKILLS)**

### **1.1. Từ "Vibe Coding" đến "Agentic Coding": Sự dịch chuyển mô hình năm 2026**

Trong giai đoạn 2024-2025, cộng đồng công nghệ đã chứng kiến sự bùng nổ của khái niệm "Vibe Coding" – một phương pháp lập trình dựa trên trực giác, nơi các lập trình viên tương tác với LLM (Large Language Models) một cách tự do, thiếu cấu trúc để tạo ra mã nguồn nhanh chóng. Mặc dù mang lại tốc độ, phương pháp này nhanh chóng bộc lộ những hạn chế nghiêm trọng khi áp dụng vào các dự án quy mô lớn: mã nguồn thiếu nhất quán, khó bảo trì, và đặc biệt là sự phụ thuộc vào "cảm tính" của mô hình tại thời điểm suy luận.1

Năm 2026 đánh dấu sự chuyển dịch sang mô hình "Agentic Coding", nơi trọng tâm không còn là việc viết mã (coding) mà là việc điều phối (orchestrating) các Agent chuyên biệt. Theo các quan sát từ thực tế triển khai, vai trò của con người đang chuyển từ "Specialist" (Chuyên gia kỹ thuật sâu) sang "Generalist" (Nhà quản lý tổng quát), người có khả năng định hướng và kiểm soát một đội ngũ AI.1 Trong mô hình này, Agent Skill chính là công cụ để "đóng gói" tri thức chuyên môn và quy trình làm việc thành các mô-đun có thể tái sử dụng, giúp biến một LLM đa năng thành một chuyên gia trong lĩnh vực cụ thể.

### **1.2. Định nghĩa và Bản chất của Agent Skill**

Một Agent Skill không đơn thuần là một câu lệnh prompt hay một tập hợp các quy tắc rời rạc. Nó là một thực thể kiến trúc hoàn chỉnh, bao gồm tri thức (Knowledge), quy trình (Process) và công cụ (Tools) được tổ chức theo một cấu trúc thư mục tiêu chuẩn.3 Khác với MCP (Model Context Protocol) – vốn đóng vai trò là "giác quan" và "tay chân" giúp Agent kết nối với thế giới bên ngoài (cơ sở dữ liệu, API), Agent Skill đóng vai trò là "bộ não quy trình", hướng dẫn Agent cách sử dụng các công cụ đó để giải quyết một vấn đề cụ thể theo đúng tiêu chuẩn của tổ chức.5

| Đặc điểm | MCP (Model Context Protocol) | Agent Skill |
| :---- | :---- | :---- |
| **Vai trò** | Kết nối, cung cấp công cụ và dữ liệu (Interfaces) | Hướng dẫn quy trình, tư duy và phương pháp luận (Workflow) |
| **Bản chất** | Kỹ thuật, xác định (Deterministic) | Quy trình, ngữ nghĩa (Semantic), hướng dẫn (Instructional) |
| **Ví dụ** | "Hàm đọc file", "Hàm truy vấn SQL" | "Kỹ năng phân tích log lỗi", "Kỹ năng viết tài liệu API" |
| **Mục tiêu** | Khả năng thực thi (Capability) | Chất lượng đầu ra (Quality & Consistency) |

Việc phân biệt rõ ràng giữa MCP và Agent Skill là nền tảng để xây dựng các hệ thống AI bền vững. Agent Skill giúp giải quyết vấn đề "Context Rot" (sự suy giảm ngữ cảnh) và "Cognitive Overload" (quá tải nhận thức) của AI bằng cách cung cấp thông tin đúng lúc, đúng chỗ thông qua cơ chế Progressive Disclosure.2

### **1.3. Nguyên tắc Progressive Disclosure (Tiết lộ lũy tiến)**

Một trong những thách thức lớn nhất trong việc phát triển Agent là giới hạn của cửa sổ ngữ cảnh (Context Window) và chi phí tính toán. Việc nạp toàn bộ tài liệu dự án, quy tắc và hướng dẫn vào mỗi lần chạy là không khả thi và kém hiệu quả. Kiến trúc Agent Skill giải quyết vấn đề này thông qua nguyên tắc **Progressive Disclosure** (Tiết lộ lũy tiến), chia thông tin thành các tầng (Tiers) khác nhau 2:

* **Tầng 1 (Mandatory \- Tier 1):** Đây là những thông tin cốt lõi bắt buộc phải được nạp ngay khi Agent kích hoạt kỹ năng. Nó bao gồm file SKILL.md (chứa định danh, quy trình tổng quan) và các tài liệu kiến thức nền tảng (knowledge/architect.md). Mục tiêu của tầng này là thiết lập "mô hình tư duy" (Mental Model) cho Agent.  
* **Tầng 2 (Conditional \- Tier 2):** Đây là các tài nguyên chỉ được nạp khi Agent thực sự cần đến trong quá trình thực thi. Ví dụ: các mẫu (templates) chi tiết, các kịch bản kiểm thử (scripts/), hoặc các danh sách kiểm tra cụ thể (loop/checklist.md). Agent sẽ tự quyết định việc đọc các file này dựa trên hướng dẫn từ Tầng 1\.

Cơ chế này không chỉ giúp tiết kiệm token mà còn giúp Agent tập trung (Focus) tốt hơn vào tác vụ hiện tại, giảm thiểu nguy cơ bị nhiễu loạn bởi các thông tin không liên quan, từ đó nâng cao độ chính xác và chất lượng của kết quả đầu ra.9

## ---

**PHẦN 2: KIẾN TRÚC "7 ZONES" – CẤU TRÚC GIẢI PHẪU CỦA MỘT AGENT SKILL**

Để đảm bảo tính nhất quán và khả năng mở rộng, mọi Agent Skill đều phải tuân thủ một cấu trúc thư mục tiêu chuẩn được gọi là "7 Zones" (7 Vùng chức năng). Cấu trúc này được định nghĩa trong tài liệu architect.md và là xương sống của toàn bộ hệ thống.2 Mỗi vùng có một chức năng riêng biệt, hỗ trợ lẫn nhau để tạo nên một thực thể kỹ năng hoàn chỉnh.

### **2.1. Zone 1: Core (Cốt lõi) – SKILL.md**

Đây là vùng quan trọng nhất, chứa file SKILL.md. File này được ví như "linh hồn" điều khiển của kỹ năng.

* **Chức năng:** Định nghĩa danh tính (Persona), mục tiêu, và quy trình thực thi cấp cao.  
* **Nội dung bắt buộc:**  
  * **Frontmatter:** Metadata định danh kỹ năng.  
  * **Persona:** Vai trò chuyên gia (ví dụ: "Senior Skill Builder").  
  * **Guardrails:** Các quy tắc an toàn bất biến (ví dụ: "Không được bịa đặt thông tin").  
  * **Workflow:** Các bước thực hiện tuần tự (5 Steps).  
* **Yêu cầu kỹ thuật:** Phải viết bằng thể mệnh lệnh (Imperative form), ngắn gọn, súc tích và tuân thủ giới hạn độ dài (thường dưới 500 dòng) để tối ưu hóa khả năng hiểu của AI.2

### **2.2. Zone 2: Knowledge (Tri thức)**

Chứa các tài liệu tham chiếu, quy chuẩn và hướng dẫn chi tiết mà Agent cần tuân thủ.

* **Chức năng:** Cung cấp "não bộ" kiến thức cho Agent.  
* **Thành phần:** standards.md (tiêu chuẩn), architect.md (kiến trúc), build-guidelines.md (hướng dẫn xây dựng).  
* **Cơ chế:** Được nạp theo nguyên tắc Progressive Disclosure. Agent tra cứu vùng này để đảm bảo sản phẩm đầu ra tuân thủ các quy chuẩn của tổ chức.2

### **2.3. Zone 3: Scripts (Kịch bản thực thi)**

Nơi chứa các đoạn mã thực thi (executable code) để hỗ trợ Agent thực hiện các tác vụ đòi hỏi sự chính xác tuyệt đối hoặc tương tác hệ thống.

* **Chức năng:** "Tay chân" của Agent, thực hiện các tác vụ như tạo thư mục, kiểm tra file, validate dữ liệu.  
* **Ngôn ngữ:** Python (xử lý logic, NLP), Bash (thao tác file), JavaScript/Node.js (xử lý JSON).  
* **Ví dụ:** validate\_skill.py – script tự động kiểm tra cấu trúc thư mục và tính toàn vẹn của skill.2

### **2.4. Zone 4: Templates (Biểu mẫu)**

Chứa các mẫu file đầu ra chuẩn để đảm bảo tính nhất quán.

* **Chức năng:** Định hình "khuôn mẫu" cho sản phẩm.  
* **Thành phần:** Các file mẫu Markdown, cấu trúc mã nguồn, hoặc sơ đồ Mermaid. Agent sẽ điền nội dung vào các khuôn mẫu này thay vì tự sáng tạo định dạng.

### **2.5. Zone 5: Data (Dữ liệu & Cấu hình)**

Chứa các file cấu hình tĩnh hoặc schema dữ liệu.

* **Chức năng:** Cung cấp tham số và định nghĩa cấu trúc dữ liệu.  
* **Thành phần:** .skillfish.json (cấu hình metadata), schema.json (JSON Schema cho việc validate đầu ra).12

### **2.6. Zone 6: Loop (Vòng lặp kiểm soát)**

Vùng chức năng quan trọng nhất để đảm bảo chất lượng, chứa các công cụ kiểm tra và danh sách việc cần làm.

* **Chức năng:** "Hệ thống miễn dịch" giúp Agent tự phát hiện và sửa lỗi.  
* **Thành phần:**  
  * checklist.md: Danh sách kiểm tra thủ công hoặc bán tự động.  
  * test-cases/: Các kịch bản kiểm thử cụ thể (ví dụ: login-flow.md).  
  * build-log.md: Nhật ký ghi lại quá trình thực thi và các quyết định.2

### **2.7. Zone 7: Assets (Tài sản bổ trợ)**

Chứa các tài nguyên tĩnh như hình ảnh, fonts, icons cần thiết cho kỹ năng (thường ít dùng trong các kỹ năng thuần về logic hoặc coding backend).

## ---

**PHẦN 3: PHƯƠNG PHÁP LUẬN XÂY DỰNG VÀ QUY TRÌNH "MASTER SKILL SUITE"**

Để xây dựng các hệ thống phần mềm phức tạp, việc dựa vào một Agent duy nhất là không đủ. Báo cáo đề xuất mô hình "Master Skill Suite" – một hệ thống phối hợp đa Agent hoạt động tuần tự và kiểm soát lẫn nhau.2

### **3.1. Bộ Ba Quyền Lực: Architect \- Planner \- Builder**

Quy trình xây dựng phần mềm được chia nhỏ thành 3 giai đoạn, mỗi giai đoạn do một Agent chuyên biệt phụ trách:

1. **Skill Architect (Kiến trúc sư):**  
   * **Nhiệm vụ:** Thiết kế kiến trúc tổng thể, xác định các thành phần (Components), vẽ sơ đồ hệ thống.  
   * **Đầu ra:** design.md (Chứa Zone Mapping, mô hình luồng dữ liệu).  
   * **Đặc điểm:** Tư duy trừu tượng, không đi sâu vào chi tiết code.2  
2. **Skill Planner (Nhà hoạch định):**  
   * **Nhiệm vụ:** Lên kế hoạch triển khai chi tiết, xác định các bước thực hiện (Phases), kiểm kê tài nguyên (Resource Audit).  
   * **Đầu ra:** todo.md (Danh sách công việc chi tiết, chia theo Phase).  
   * **Đặc điểm:** Tư duy tổ chức, quản lý rủi ro, xác định các điểm nghẽn (Bottlenecks).2  
3. **Skill Builder (Thợ xây):**  
   * **Nhiệm vụ:** Thực thi kế hoạch, viết mã, tạo file, chạy kiểm thử.  
   * **Đầu ra:** Mã nguồn hoàn chỉnh, cấu trúc thư mục, báo cáo kiểm thử.  
   * **Đặc điểm:** Tư duy thực thi, tuân thủ tuyệt đối thiết kế và kế hoạch.2

Mô hình này tạo ra cơ chế "Checks and Balances" (Kiểm soát và Đối trọng). Architect thiết kế sai thì Planner sẽ phát hiện khi lên kế hoạch. Planner thiếu sót tài nguyên thì Builder sẽ báo cáo khi thực thi.

### **3.2. Vòng Đời 5 Bước (The 5-Step Lifecycle)**

Hoạt động của Skill Builder tuân theo quy trình 5 bước nghiêm ngặt, được thiết kế để tối đa hóa độ chính xác và giảm thiểu rủi ro 2:

1. **PREPARE (Chuẩn bị):**  
   * Agent đọc và phân tích toàn bộ đầu vào (design.md, todo.md).  
   * Xây dựng mô hình tư duy (Mental Model) về công việc cần làm.  
   * Thực hiện "Missing Resources Audit" để phát hiện các tài nguyên còn thiếu trước khi bắt đầu.  
2. **CLARIFY (Làm rõ):**  
   * Đây là bước "Gatekeeper" đầu tiên. Agent quét danh sách todo.md để tìm các mục đánh dấu \`\`.  
   * Thực hiện hỏi người dùng (tối đa 5 câu hỏi mỗi phiên) để làm rõ các điểm mờ.  
   * Ghi nhận câu trả lời vào phần "Clarifications" trong design.md để đảm bảo tính nhất quán.2  
3. **BUILD (Xây dựng):**  
   * Tiến hành tạo file và viết nội dung dựa trên thiết kế.  
   * Áp dụng "Logic Placeholder": Nếu thiếu thông tin chi tiết, Agent phải tạo khung (skeleton) và để lại ghi chú TODO, tuyệt đối không được tự ý bịa đặt (hallucinate) thông tin.2  
4. **VERIFY (Xác minh):**  
   * Chạy các script kiểm tra tự động (validate\_skill.py).  
   * Đối chiếu sản phẩm thực tế với thiết kế (design.md) và kế hoạch (todo.md).  
   * Kiểm tra tính tuân thủ các quy tắc Progressive Disclosure (PD Check).  
5. **DELIVER (Bàn giao):**  
   * Tổng hợp kết quả, cập nhật nhật ký build-log.md.  
   * Báo cáo trạng thái cuối cùng (Pass/Fail) và các vấn đề còn tồn đọng cho người dùng.

## ---

**PHẦN 4: CƠ CHẾ KIỂM SOÁT CHẤT LƯỢNG VÀ TIÊU CHUẨN "GATEKEEPER"**

Trong môi trường Agentic Coding, "Gatekeeper" (Người gác cổng) không phải là con người, mà là tập hợp các tiêu chuẩn kỹ thuật và điều kiện tiên quyết (Prerequisites) được mã hóa thành luật.2

### **4.1. Định nghĩa Tiêu chuẩn Gatekeeper**

Gatekeeper hoạt động như một chốt chặn tại các điểm chuyển giao giữa các giai đoạn (Phases).

* **Gatekeeper Phase 0 (Knowledge Acquisition):** Trước khi bước vào giai đoạn Build, hệ thống kiểm tra xem thư mục resources/ có đầy đủ "Rich Content" (Nội dung giàu thông tin) hay không. Nếu thiếu các tài liệu hướng dẫn (build-guidelines.md) hoặc logic xác thực (validation-logic.md), quy trình sẽ bị chặn lại (Block). Điều này ngăn chặn việc Agent thực thi dựa trên sự thiếu hiểu biết.2  
* **Gatekeeper Confidence Score:** Trong quá trình thực thi, nếu mức độ tự tin (Confidence Score) của Agent giảm xuống dưới 70%, nó buộc phải dừng lại và kích hoạt điểm tương tác (Interaction Point) để hỏi ý kiến người dùng.2

### **4.2. Logic Xác thực Tự động (Automated Validation Logic)**

Việc kiểm tra chất lượng không dựa trên cảm tính mà dựa trên các tiêu chí đo lường được (Measurable Criteria), được thực thi bởi các script tự động 2:

1. **4-Zone Check (Kiểm tra Cấu trúc):**  
   * Logic: Quét thư mục gốc, đảm bảo sự hiện diện của 4 vùng bắt buộc: Core, Knowledge, Scripts, Loop.  
   * Điều kiện Fail: Thiếu bất kỳ vùng nào trong 4 vùng trên.  
2. **PD Check (Kiểm tra Phân tầng thông tin):**  
   * Logic: Phân tích file SKILL.md (Tier 1\) để tìm các liên kết (links) dẫn đến các file trong scripts/ và loop/ (Tier 2).  
   * Điều kiện Fail: Có file tồn tại trong Tier 2 nhưng không được tham chiếu (link) từ Tier 1 (dẫn đến "Dead Code" hoặc thông tin mồ côi).  
3. **File List Comparison (Đối chiếu Danh sách File):**  
   * Logic: So sánh danh sách file thực tế (Actual) trên đĩa cứng với danh sách file được quy định trong design.md (Expected).  
   * Điều kiện Fail: Số lượng hoặc tên file không khớp (Thừa hoặc Thiếu).

### **4.3. Cơ chế "Loop" và "Rollback"**

Hệ thống không chấp nhận việc sửa lỗi tạm bợ. Khi phát hiện lỗi ở giai đoạn N (ví dụ: Verify), quy trình bắt buộc Agent thực hiện Rollback 2:

1. Ghi nhận lỗi và nguyên nhân vào build-log.md.  
2. Thông báo cho người dùng.  
3. Quay ngược lại giai đoạn M (nơi phát sinh lỗi gốc, ví dụ: Design hoặc Build).  
4. Thực hiện lại quy trình từ M đến N.  
   Cơ chế này đảm bảo tính toàn vẹn dữ liệu và ngăn chặn sự tích tụ nợ kỹ thuật trong quá trình phát triển.

## ---

**PHẦN 5: XÂY DỰNG NỘI DUNG TÀI LIỆU TIÊU CHUẨN (SPECIFICATION)**

Phần này cung cấp nội dung chi tiết, sẵn sàng để sử dụng (ready-to-use) cho hai tài liệu quan trọng được yêu cầu: build-guidelines.md và validation-logic.md. Nội dung được biên soạn dựa trên các nguyên tắc "Rich Content" và "Technical Spec" đã phân tích ở trên.

### **5.1. Tài liệu resources/build-guidelines.md (Hướng dẫn Xây dựng)**

Đây là tài liệu hướng dẫn tác nghiệp dành cho Agent Builder, quy định cách viết và tổ chức nội dung.

# **BUILD GUIDELINES: HƯỚNG DẪN XÂY DỰNG VÀ TRIỂN KHAI AGENT SKILL (GATEKEEPER STANDARD)**

Tài liệu này thiết lập các tiêu chuẩn kỹ thuật và quy tắc thực thi bắt buộc (Mandatory Rules) cho việc xây dựng các Agent Skill. Mọi sản phẩm đầu ra phải tuân thủ nghiêm ngặt các hướng dẫn này để vượt qua các bài kiểm tra chất lượng (Validation Gates).

## **1\. NGUYÊN TẮC CỐT LÕI KHI VIẾT SKILL.md (CORE ZONE)**

SKILL.md là trung tâm điều khiển của kỹ năng. Nó phải được tối ưu hóa cho khả năng đọc hiểu của máy (Machine Readability) và tuân thủ các ràng buộc về tài nguyên.

### **1.1. Phong cách Ngôn ngữ (Imperative Form)**

* **Quy tắc:** Sử dụng tuyệt đối thể mệnh lệnh (Imperative mood). Bắt đầu mọi hướng dẫn bằng một Động từ hành động mạnh (Action Verb).  
* **Cấm:** Không sử dụng thể bị động, ngôn ngữ gợi ý, hoặc các từ ngữ lịch sự thừa thãi ("please", "you should", "can you").  
* **Ví dụ So sánh:**  
  * ❌ **Sai (Verbose/Weak):** "You should clearly analyze the input provided by the user to understand the context."  
  * ✅ **Đúng (Imperative/Strong):** "Analyze user input. Extract context and intent."  
  * ✅ **Đúng:** "Execute validation script scripts/validate.py."

### **1.2. Ràng buộc về Độ dài và Cấu trúc**

* **Giới hạn cứng:** File SKILL.md không được vượt quá **500 dòng**.  
* **Xử lý vượt ngưỡng:** Nếu nội dung quá dài, bắt buộc phải tách các phần chi tiết sang thư mục knowledge/ hoặc loop/ và sử dụng cơ chế Progressive Disclosure để tham chiếu.  
* **Cấu trúc Bắt buộc (Standard Layout):**  
  1. **Frontmatter (YAML):** Định nghĩa name, description, version, author.  
  2. **Persona:** Định danh vai trò chuyên gia (VD: "Senior Skill Builder").  
  3. **Context:** Bối cảnh và mục tiêu sử dụng.  
  4. **Workflow (The 5 Steps):** Định nghĩa rõ 5 bước: PREPARE \-\> CLARIFY \-\> BUILD \-\> VERIFY \-\> DELIVER.  
  5. **Guardrails:** Các quy tắc an toàn và kiểm soát rủi ro.

### **1.3. Cơ chế Progressive Disclosure (Phân tầng thông tin)**

* **Tier 1 (Core \- Mandatory):** Chỉ chứa thông tin điều phối luồng (Flow Control) và các quy tắc cấp cao.  
* **Tier 2 (Detail \- Conditional):** Các hướng dẫn chi tiết, mẫu code, danh sách kiểm tra phải nằm trong file riêng.  
* **Quy tắc Liên kết:** SKILL.md phải chứa đường dẫn tương đối (Relative Paths) đến tất cả các file Tier 2\.  
  * Ví dụ: Step 4: Verify output using \[Checklist\](loop/build-checklist.md).

## **2\. QUY TẮC XỬ LÝ NỘI DUNG VÀ PLACEHOLDER (CONTENT HANDLING)**

Để ngăn chặn hiện tượng ảo giác (Hallucination) khi thiếu dữ liệu đầu vào, Builder phải tuân thủ logic xử lý sau:

### **2.1. Logic Placeholder (Xử lý thiếu dữ liệu Domain)**

* **Nguyên tắc:** "Không có dữ liệu đầu vào thì không được sáng tạo nội dung chuyên môn".  
* **Hành động:** Khi phát hiện thiếu thông tin trong resources/:  
  1. Vẫn tạo cấu trúc file (Skeleton) theo đúng chuẩn thiết kế.  
  2. Tại vị trí thiếu nội dung, chèn khối Placeholder (Giữ chỗ) với định dạng rõ ràng.  
  3. Thêm ghi chú \`\` yêu cầu người dùng điền thông tin sau này.

* ## **\*\*Mẫu Placeholder:\*\*markdown**   **3\. Business Logic DetailsMISSING DOMAIN DATA**   **The resource input did not contain specific business logic rules.**   **ACTION REQUIRED: User to populate this section with specific domain constraints.** 

### **2.2. Zone Knowledge**

* Mọi file trong knowledge/ phải có phần header mô tả "Usage" (Cách sử dụng) để Agent biết khi nào cần đọc file đó.

## **3\. TIÊU CHUẨN LOOP CHECKLIST (LOOP ZONE)**

File loop/build-checklist.md phải được thiết kế để đo lường được (Measurable) và kiểm chứng được (Verifiable).

### **3.1. Cấu trúc 4 Trục (The 4-Axis Structure)**

Checklist phải bao gồm 4 phần kiểm tra riêng biệt:

1. **Structure Check (Kiểm tra Cấu trúc):**  
   * Xác nhận sự hiện diện của 4 Zone bắt buộc.  
   * Xác nhận đúng quy tắc đặt tên file/folder.  
2. **Source Check (Kiểm tra Nguồn):**  
   * Xác nhận nội dung khớp với design.md.  
   * Xác nhận các mục \`\` đã được giải quyết.  
3. **PD Check (Kiểm tra Phân tầng):**  
   * Xác nhận mọi file Tier 2 đều được link từ Tier 1\.  
   * Không có file mồ côi (Orphan files).  
4. **Completeness Check (Kiểm tra Hoàn thiện):**  
   * Xác nhận không còn placeholder TODO nào chưa được báo cáo (hoặc đã được xử lý).  
   * Xác nhận script validation chạy PASS (Exit code 0).

### **3.2. Định dạng Item**

Mỗi mục kiểm tra phải là một checkbox Markdown chuẩn:

* \- \[ \] SKILL.md length is \< 500 lines.  
* \- \[ \] Validate script returns Exit Code 0\.

---

*End of Build Guidelines*

\#\#\# 5.2. Tài liệu \`resources/validation-logic.md\` (Logic Xác thực)

Đây là bản đặc tả kỹ thuật (Technical Specification) dùng để phát triển script tự động hóa \`validate\_skill.py\`.

\# VALIDATION LOGIC SPECIFICATION: ĐẶC TẢ KỸ THUẬT KIỂM TRA TỰ ĐỘNG

Tài liệu này định nghĩa logic nghiệp vụ chi tiết, các hàm kiểm tra và mã lỗi (Error Codes) cho script \`scripts/validate\_skill.py\`. Script này hoạt động như một "Gatekeeper" tự động cuối cùng trước khi bàn giao sản phẩm.

\#\# 1\. TỔNG QUAN HỆ THỐNG  
\*   \*\*Target:\*\* Thư mục gốc của gói Agent Skill vừa được xây dựng.  
\*   \*\*Input:\*\* Đường dẫn (Path) đến thư mục skill.  
\*   \*\*Output:\*\* Báo cáo (Report) in ra console và ghi vào \`build-log.md\`.  
\*   \*\*Exit Codes:\*\*  
    \*   \`0\`: Success (Tất cả kiểm tra đều PASS).  
    \*   \`1\`: Validation Error (Có ít nhất 1 lỗi Critical/Major).

\#\# 2\. CÁC MODULE KIỂM TRA (MANDATORY CHECKS)

Script cần triển khai 4 hàm kiểm tra cốt lõi sau:

\#\#\# 2.1. Module: Check Structural Integrity (\`check\_structure\`)  
\*   \*\*Mục tiêu:\*\* Đảm bảo khung xương sống của kỹ năng tồn tại đầy đủ.  
\*   \*\*Logic:\*\*  
    1\.  Quét thư mục gốc của skill.  
    2\.  Kiểm tra sự tồn tại (File Existence Check) của các thành phần bắt buộc:  
        \*   File: \`SKILL.md\`  
        \*   Directory: \`knowledge/\`  
        \*   Directory: \`scripts/\`  
        \*   Directory: \`loop/\`  
    3\.  \*\*Pass Condition:\*\* Tìm thấy đủ 4 thành phần trên.  
    4\.  \*\*Fail Condition:\*\* Thiếu bất kỳ thành phần nào.  
    5\.  \*\*Error Message:\*\* \`\[E01\] CRITICAL: Missing mandatory zone: {missing\_zone}\`.

\#\#\# 2.2. Module: Check Progressive Disclosure (\`check\_pd\_links\`)  
\*   \*\*Mục tiêu:\*\* Đảm bảo tính liên kết chặt chẽ giữa Tầng 1 (Core) và Tầng 2 (Resources).  
\*   \*\*Logic:\*\*  
    1\.  Đọc nội dung file \`SKILL.md\` vào bộ nhớ.  
    2\.  Quét đệ quy các thư mục Tier 2 (\`knowledge/\`, \`scripts/\`, \`loop/\`) để lấy danh sách tất cả các file con (Actual Files).  
    3\.  Với mỗi file trong danh sách Actual Files:  
        \*   Sử dụng Regex để tìm kiếm tên file hoặc đường dẫn tương đối của nó trong nội dung \`SKILL.md\`.  
        \*   Regex Pattern: \`r"\\\[.\*\\\]\\(.\*{filename}.\*\\)"\` (Tìm kiếm cú pháp Markdown link).  
    4\.  \*\*Pass Condition:\*\* Tên file hoặc đường dẫn xuất hiện trong \`SKILL.md\`.  
    5\.  \*\*Fail Condition:\*\* File tồn tại trong thư mục nhưng không được tham chiếu trong \`SKILL.md\`.  
    6\.  \*\*Warning Message:\*\* \` WARNING: Orphan file detected. '{filename}' exists but is not linked in SKILL.md\`.

\#\#\# 2.3. Module: Check File Consistency (\`check\_file\_mapping\`)  
\*   \*\*Mục tiêu:\*\* Đảm bảo sản phẩm thực tế khớp 100% với bản thiết kế.  
\*   \*\*Input:\*\*  
    \*   \`expected\_list\`: Danh sách file được parse từ section "Zone Mapping" của \`design.md\`.  
    \*   \`actual\_list\`: Danh sách file thực tế quét được từ ổ đĩa.  
\*   \*\*Logic:\*\*  
    1\.  Thực hiện so sánh tập hợp (Set Comparison).  
    2\.  Xác định \`Missing Files\` \= \`expected\_list\` \- \`actual\_list\`.  
    3\.  Xác định \`Extra Files\` \= \`actual\_list\` \- \`expected\_list\`.  
    4\.  \*\*Pass Condition:\*\* Cả hai danh sách Missing và Extra đều rỗng.  
    5\.  \*\*Fail Condition:\*\* \`Missing Files\` không rỗng.  
    6\.  \*\*Error Message:\*\* \`\[E02\] ERROR: Deviation from Design. Missing files: {missing\_files}\`.

\#\#\# 2.4. Module: Check Core Constraints (\`check\_skill\_md\`)  
\*   \*\*Mục tiêu:\*\* Kiểm soát chất lượng kỹ thuật của file Core.  
\*   \*\*Logic:\*\*  
    1\.  Đếm số dòng (Line Count) của \`SKILL.md\`.  
    2\.  Kiểm tra sự hiện diện của các Keyword bắt buộc:  
        \*   \`Persona:\`  
        \*   \`Workflow\` hoặc \`Steps\`  
        \*   \`Guardrails\`  
    3\.  \*\*Fail Condition 1:\*\* Số dòng \> 500 (\`\[E03\] ERROR: SKILL.md exceeds 500 lines limit\`).  
    4\.  \*\*Fail Condition 2:\*\* Thiếu Keyword (\`\[E04\] ERROR: SKILL.md missing mandatory section: {missing\_section}\`).

\#\# 3\. CƠ CHẾ BÁO CÁO (REPORTING)

\#\#\# 3.1. Console Output Template  
Kết quả cần được in ra màn hình theo định dạng bảng dễ đọc:text  
\==================================================  
   AGENT SKILL VALIDATION REPORT  
   Target: {skill\_name}  
   Time: {timestamp}  
\==================================================  
1\.  Checking 4 Zones.........  
2\. SKILL.md Length......... (340 lines)  
3\. \[MAPPING\]    File Consistency.........  
4\.   Progressive Disclosure... \[FAIL\]  
   \-\> Orphan file: loop/extra\_check.md  
\==================================================  
FINAL STATUS: FAIL (Due to Warnings/Errors)  
See build-log.md for details.

### **3.2. Log Integration**

* Script phải có chế độ \--log để ghi (append) toàn bộ nội dung báo cáo trên vào cuối file loop/build-log.md. Điều này đảm bảo tính truy vết (Traceability) cho bước DELIVER.

---

*End of Validation Spec*

\---

\#\# PHẦN 6: PHÂN TÍCH CHIẾN LƯỢC VÀ KHUYẾN NGHỊ TRIỂN KHAI

\#\#\# 6.1. Phân tích Dữ liệu và Các Xu hướng Cốt lõi (Second & Third-Order Insights)

Từ việc tổng hợp các nguồn dữ liệu, có thể rút ra những nhận định sâu sắc về xu hướng phát triển của Agent Skill:

1\.  \*\*Sự chuyển dịch từ "Capability" sang "Reliability":\*\* Nếu như năm 2024-2025 tập trung vào việc làm cho AI "làm được việc" (Capability), thì năm 2026 tập trung vào việc làm cho AI "làm việc một cách tin cậy" (Reliability). Cấu trúc 7 Zones và các cơ chế Gatekeeper chính là sự cụ thể hóa của xu hướng này. Chúng biến quy trình phát triển phần mềm bằng AI từ một nghệ thuật ngẫu hứng thành một quy trình kỹ thuật công nghiệp có thể đo lường và kiểm soát được.\[1, 3\]

2\.  \*\*Vai trò của "Context Engineering":\*\* Việc quản lý ngữ cảnh (Context) đang trở thành kỹ năng quan trọng nhất của kỹ sư phần mềm. "Context Rot" (Ngữ cảnh bị thoái hóa/nhiễu) là nguyên nhân chính dẫn đến sai sót của AI. Nguyên tắc Progressive Disclosure không chỉ là một kỹ thuật tiết kiệm chi phí mà là một chiến lược quản trị tri thức, đảm bảo "Cognitive Hygiene" (Vệ sinh nhận thức) cho AI.\[7\]

3\.  \*\*Sự trỗi dậy của "Agent Ops":\*\* Việc yêu cầu các script kiểm tra tự động (\`validate\_skill.py\`) và nhật ký xây dựng (\`build-log.md\`) cho thấy sự hình thành của quy trình vận hành Agent (Agent Ops) tương tự như DevOps. Chúng ta đang bắt đầu quản lý các "nhân viên số" (Digital Workers) bằng các công cụ CI/CD chuyên nghiệp.

\#\#\# 6.2. Khuyến nghị Triển khai (Actionable Recommendations)

Dựa trên báo cáo, để triển khai thành công bộ Agent Skill, tổ chức cần thực hiện các bước sau:

1\.  \*\*Chuẩn hóa Phase 0:\*\* Trước khi bắt đầu bất kỳ dự án nào, phải đảm bảo thư mục \`resources/\` chứa đầy đủ các tài liệu \`build-guidelines.md\` và \`validation-logic.md\` theo nội dung đã cung cấp ở Phần 5\. Đây là điều kiện tiên quyết (Pre-requisite) không thể bỏ qua.  
2\.  \*\*Tích hợp Validation vào Workflow:\*\* Script \`validate\_skill.py\` không nên chỉ là công cụ chạy thủ công. Nó cần được tích hợp vào quy trình làm việc của Agent như một bước bắt buộc (Hard Gate). Agent không được phép chuyển sang bước DELIVER nếu Script này trả về kết quả FAIL.  
3\.  \*\*Đào tạo Tư duy "Architect":\*\* Đội ngũ nhân sự cần được đào tạo để chuyển dịch từ tư duy viết mã sang tư duy thiết kế hệ thống và quy trình. Khả năng viết tài liệu \`design.md\` rõ ràng và logic sẽ quan trọng hơn khả năng tối ưu hóa một thuật toán cụ thể.

\#\# KẾT LUẬN

Hệ thống Agent Skill với kiến trúc 7 Zones, quy trình 5 bước và các cơ chế kiểm soát Gatekeeper đại diện cho sự trưởng thành của công nghệ AI trong môi trường doanh nghiệp. Bằng việc áp dụng các tiêu chuẩn nghiêm ngặt về Progressive Disclosure và Validation Logic, chúng ta không chỉ giải quyết được các vấn đề kỹ thuật như giới hạn token hay ảo giác, mà còn xây dựng được nền tảng niềm tin vững chắc để AI có thể tham gia sâu hơn vào các quy trình sản xuất cốt lõi. Hai tài liệu \`build-guidelines.md\` và \`validation-logic.md\` được cung cấp trong báo cáo này chính là những viên gạch đầu tiên để hiện thực hóa tầm nhìn đó.

#### **Nguồn trích dẫn**

1. 2026 \- Here we go\!, [https://mail.google.com/mail/u/0/\#all/FMfcgzQfBGWzLZQDRVQDNNNClZBzjTMT](https://mail.google.com/mail/u/0/#all/FMfcgzQfBGWzLZQDRVQDNNNClZBzjTMT)  
2. design.md  
3. Agent Skills \- Claude API Docs, truy cập vào tháng 2 14, 2026, [https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)  
4. VoltAgent/awesome-agent-skills: Claude Code Skills and 300+ agent skills from official dev teams and the community, compatible with Codex, Antigravity, Gemini CLI, Cursor and others. \- GitHub, truy cập vào tháng 2 14, 2026, [https://github.com/VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)  
5. The Complete Guide to Building Skills for Claude | Anthropic, truy cập vào tháng 2 14, 2026, [https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf?hsLang=en](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf?hsLang=en)  
6. How to Build Claude Skills: Lesson Plan Generator Tutorial \- Codecademy, truy cập vào tháng 2 14, 2026, [https://www.codecademy.com/article/how-to-build-claude-skills](https://www.codecademy.com/article/how-to-build-claude-skills)  
7. Progressive Disclosure in Claude Code \- YouTube, truy cập vào tháng 2 14, 2026, [https://www.youtube.com/watch?v=DQHFow2NoQc](https://www.youtube.com/watch?v=DQHFow2NoQc)  
8. Introduction to Claude Skills, truy cập vào tháng 2 14, 2026, [https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction)  
9. Claude Code & Progressive Disclosure: Insights from My Learning \- Medium, truy cập vào tháng 2 14, 2026, [https://medium.com/@quanap5/claude-code-progressive-disclosure-insights-from-my-learning-5244bc9864aa](https://medium.com/@quanap5/claude-code-progressive-disclosure-insights-from-my-learning-5244bc9864aa)  
10. Agent Skills: On-the-fly capabilities for your AI Agents \- Tutorials Dojo, truy cập vào tháng 2 14, 2026, [https://tutorialsdojo.com/agent-skills-on-the-fly-capabilities-for-your-ai-agents/](https://tutorialsdojo.com/agent-skills-on-the-fly-capabilities-for-your-ai-agents/)  
11. zebbern/agent-skills-guide: Guide for creating agent skill files, with examples, templates, and best practices for building custom agent capabilities \- GitHub, truy cập vào tháng 2 14, 2026, [https://github.com/zebbern/agent-skills-guide](https://github.com/zebbern/agent-skills-guide)  
12. Zod Schema Validation | Claude Code Skill for AI Coding \- MCP Market, truy cập vào tháng 2 14, 2026, [https://mcpmarket.com/tools/skills/zod-schema-validation-1](https://mcpmarket.com/tools/skills/zod-schema-validation-1)