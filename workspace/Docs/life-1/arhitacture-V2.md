---                                                                                      
  🔄 CẬP NHẬT: ROADMAP ĐIỀU CHỈNH CHO DỰ ÁN DEMO                                           
                                                                                           
  Dựa trên câu trả lời của bạn, đây là roadmap thực tế cho dự án:                          
                                                                                           
  ┌─────────────────────────────────────────────────────────────────────────────┐          
  │                    TECH STACK ĐÃ XÁC ĐỊNH                                   │          
  ├─────────────────────────────────────────────────────────────────────────────┤          
  │ Frontend:    Next.js 16 + React 19 + TypeScript                             │           
  │ Backend:     Payload CMS 3.x                                                │          
  │ Database:    MongoDB Atlas                                                  │          
  │ Styling:     Tailwind CSS + Shadcn UI                                       │          
  │ Storage:     Local Server Storage (Disk)                   │          
  │ Realtime:    SSE (Server-Sent Events)                                       │          
  │ Search:      MongoDB Atlas Search                                           │          
  │ Hosting:     Vercel                                                         │          
  │ CI/CD:       Vercel Auto-Deploy                                             │          
  │ Monitoring:  Vercel Analytics                                               │          
  │ Queue:       Không (xử lý đồng bộ trong MVP)                                │          
  └─────────────────────────────────────────────────────────────────────────────┘          
                                                                                           
  ---                                                                                      
  📋 GIAI ĐOẠN 1 ĐIỀU CHỈNH - XÁC ĐỊNH YÊU CẦU (CHO DỰ ÁN DEMO)                            
                                                                                           
  ✅ Checklist công việc (Đã loại bỏ nghiên cứu thị trường)                                
                                                                                           
  GIAI ĐOẠN 1: XÁC ĐỊNH YÊU CẦU (Simplified for Demo)                                      
  ═══════════════════════════════════════════════════════════════                          
                                                                                           
  ✓ 1.1 Nghiên cứu & Phân tích → BỎ QUA (dự án demo)                                       
                                                                                           
  □ 1.2 Xác định người dùng mục tiêu                                                       
     □ Tạo 2-3 User Personas đơn giản:                                                     
        - Developer (junior/senior)                                                        
        - Student (CNTT)                                                                   
        - Tech enthusiast                                                                  
     □ Xác định pain points: nơi chia sẻ kiến thức tech Việt Nam còn thiếu                 
                                                                                           
  □ 1.3 Xây dựng User Stories (Focus MVP)                                                  
     □ Epic 1: Authentication (Email/Password + OAuth Google)                              
     □ Epic 2: Profile Management (Avatar, Bio, Social links)                              
     □ Epic 3: Content Creation (Text + Image + Link)                                      
     □ Epic 4: Social Bookmarking với Collections                                          
     □ Epic 5: News Feed với ranking algorithm                                             
     □ Epic 6: Interactions (Like, Comment, Share)                                         
     □ Epic 7: Search (Users, Posts, Tags)                                                 
     □ Epic 8: Realtime Notifications (SSE)                                                
     □ Epic 9: Moderation (Auto-approve + Report system)                                   
     □ Epic 10: Privacy & Connections                                                      
                                                                                           
  □ 1.4 NGHIÊN CỨU KỸ THUẬT (Mới thêm - quan trọng!)                                       
     □ Nghiên cứu News Feed Ranking Algorithm:                                             
        - Reddit's hot ranking                                                             
        - Hacker News algorithm                                                            
        - Time-decay + engagement score                                                    
        - Chọn 1 thuật toán phù hợp để implement                                           
                                                                                           
     □ Nghiên cứu SSE implementation với Next.js:                                          
        - Route Handlers cho SSE                                                           
        - Client-side EventSource                                                          
        - Reconnection strategy                                                            
                                                                                           
     □ Nghiên cứu MongoDB Atlas Search:                                                    
        - Full-text search indexes                                                         
        - Autocomplete                                                                     
        - Faceted search                                                                   
                                                                                           
  □ 1.5 Đặc tả yêu cầu chi tiết                                                            
     □ Functional Requirements cho 10 MVP features                                         
     □ Non-functional Requirements:                                                        
        - Performance: Page load < 3s                                                      
        - Search response < 500ms                                                          
        - SSE latency < 1s                                                                 
     □ Database Schema design (chi tiết 9 collections)                                     
     □ API Endpoints specification                                                         
                                                                                           
  □ 1.6 Setup môi trường phát triển                                                        
     □ Init Next.js 15 project với App Router                                              
     □ Setup Payload CMS local                                                             
     □ Configure MongoDB Atlas (free tier)                                                 
     □ Setup Vercel project                                                                
     □ Configure TypeScript + ESLint + Prettier                                            
                                                                                           
  ---                                                                                      
  🎯 CÁC QUYẾT ĐỊNH ĐÃ XÁC ĐỊNH                                                            
  Câu hỏi: Target Users                                                                    
  Quyết định: Developer, Sinh viên CNTT, Tech learners                                     
  Notes: Content-centric community                                                         
  ────────────────────────────────────────                                                 
  Câu hỏi: Monetization                                                                    
  Quyết định: Không                                                                        
  Notes: Dự án demo                                                                        
  ────────────────────────────────────────                                                 
  Câu hỏi: Content Types                                                                   
  Quyết định: Text + Image + Link sharing                                                  
  Notes: Không video trong MVP                                                             
  ────────────────────────────────────────                                                 
  Câu hỏi: Bookmarking                                                                     
  Quyết định: ✅ Collections/Folders                                                       
  Notes: Core feature                                                                      
  ────────────────────────────────────────                                                 
  Câu hỏi: Realtime                                                                        
  Quyết định: ✅ SSE                                                                       
  Notes: Notifications + Live updates                                                      
  ────────────────────────────────────────                                                 
  Câu hỏi: Moderation                                                                      
  Quyết định: Auto-approve + Report system                                                 
  Notes: Human admin review reports                                                        
  ────────────────────────────────────────                                                 
  Câu hỏi: News Feed                                                                       
  Quyết định: Ranking algorithm                                                            
  Notes: Cần nghiên cứu thêm                                                               
  ────────────────────────────────────────                                                 
  Câu hỏi: File Storage                                                                    
  Quyết định: Local Server Storage                                                         
  Notes: Lưu trữ trực tiếp trong thư mục dự án (public/media)                              
  ────────────────────────────────────────                                                 
  Câu hỏi: Search                                                                          
  Quyết định: MongoDB Atlas Search                                                         
  Notes:                                                                                   
  ────────────────────────────────────────                                                 
  Câu hỏi: Queue System                                                                    
  Quyết định: ❌ Không (đồng bộ)                                                           
  Notes: Đơn giản hóa MVP                                                                  
  ────────────────────────────────────────                                                 
  Câu hỏi: Hosting                                                                         
  Quyết định: Vercel                                                                       
  Notes: Auto-deploy                                                                       
  ────────────────────────────────────────                                                 
  Câu hỏi: Database                                                                        
  Quyết định: MongoDB Atlas                                                                
  Notes: Free tier 512MB                                                                   
  ────────────────────────────────────────                                                 
  Câu hỏi: Monitoring                                                                      
  Quyết định: Vercel Analytics                                                             
  Notes:                                                                                   
  ---                                                                                      
  🔬 RESEARCH TASKS - ƯU TIÊN CAO                                                          
                                                                                           
  Đây là các task nghiên cứu kỹ thuật cần làm TRƯỚC KHI CODE:                              
                                                                                           
  1️⃣ News Feed Ranking Algorithm (QUAN TRỌNG!)                                             
                                                                                           
  ┌─────────────────────────────────────────────────────────────────┐                      
  │          CÁC THUẬT TOÁN RANKING PHỔ BIẾN                        │                      
  ├─────────────────────────────────────────────────────────────────┤                      
  │                                                                 │                      
  │ A) REDDIT "HOT" ALGORITHM                                       │                      
  │    score = log(upvotes) + (age_in_hours / 12.5)                │                       
  │    Pros: Đơn giản, balance viral + fresh                       │                       
  │    Cons: Cần nhiều engagement data                             │                       
  │                                                                 │                      
  │ B) HACKER NEWS ALGORITHM                                        │                      
  │    score = (points - 1) / (age_in_hours + 2)^1.8              │                        
  │    Pros: Decay nhanh, ưu tiên fresh content                    │                       
  │    Cons: Old viral posts biến mất nhanh                        │                       
  │                                                                 │                      
  │ C) TIME-DECAY + ENGAGEMENT (SIMPLE)                            │                       
  │    score = (likes + comments*2 + shares*3) / age_weight       │                        
  │    age_weight = 1 + (hours_since_post / 24)                   │                        
  │    Pros: Dễ implement, customize được                          │                       
  │    Cons: Cần tune parameters                                   │                       
  │                                                                 │                      
  │ D) WILSON SCORE (BAYESIAN)                                     │                       
  │    Dùng cho rating systems                                      │                      
  │    Pros: Statistically sound                                   │                       
  │    Cons: Phức tạp cho MVP                                      │                       
  │                                                                 │                      
  └─────────────────────────────────────────────────────────────────┘                      
                                                                                           
  ĐỀ XUẤT CHO MVP: Option C (Time-decay + Engagement)                                      
  Lý do:                                                                                   
  - Đơn giản implement                                                                     
  - Customize được weights                                                                 
  - Phù hợp social network content-centric                                                 
                                                                                           
  Action items:                                                                            
  - Query NotebookLM về "News Feed ranking algorithm best practices"                       
  - Prototype 3 algorithms trong MongoDB Aggregation Pipeline                              
  - Benchmark performance với 10k posts                                                    
  - Chọn 1 algorithm cho MVP                                                               
                                                                                           
  2️⃣ SSE với Next.js 15 App Router                                                         
                                                                                           
  // Cần research:                                                                         
  // 1. Route Handler cho SSE endpoint                                                     
  // 2. ReadableStream implementation                                                      
  // 3. Client EventSource connection                                                      
  // 4. Reconnection logic                                                                 
  // 5. Error handling & fallback                                                          
                                                                                           
  Action items:                                                                            
  - Đọc Next.js docs về Streaming                                                          
  - POC simple SSE notification                                                            
  - Test với nhiều concurrent connections                                                  
  - Xử lý reconnection khi deploy                                                          
                                                                                           
  3️⃣ MongoDB Atlas Search Setup                                                            
                                                                                           
  // Cần research:                                                                         
  // 1. Atlas Search index creation                                                        
  // 2. $search aggregation stage                                                          
  // 3. Autocomplete configuration                                                         
  // 4. Highlighting search results                                                        
                                                                                           
  Action items:                                                                            
  - Tạo free Atlas cluster                                                                 
  - Setup search index cho posts collection                                                
  - Test full-text search performance                                                      
  - Implement autocomplete                                                                 
                                                                                           
  ---                                                                                      
  📊 MVP FEATURES - ƯU TIÊN LẠI                                                            
                                                                                           
  Dựa trên quyết định mới, đây là thứ tự ưu tiên:                                          
                                                                                           
  SPRINT 1 (Core Foundation)                                                               
  ├─ 1. Authentication (Email + OAuth Google)                                              
  ├─ 2. User Profile (Avatar, Bio)                                                         
  └─ Setup: MongoDB, Local Storage, Basic UI                                                 
                                                                                           
  SPRINT 2 (Content Creation)                                                              
  ├─ 4. Post Creation (Text + Image + Link)                                                
  ├─ 5. Interactions (Like, Comment)                                                       
  └─ 9b. Bookmarking (Save + Collections) ← CORE FEATURE                                   
                                                                                           
  SPRINT 3 (Discovery)                                                                     
  ├─ 3. News Feed (Ranking Algorithm) ← RESEARCH NEEDED                                    
  ├─ 9. Search (MongoDB Atlas Search)                                                      
  └─ 6. Connections (Follow/Unfollow)                                                      
                                                                                           
  SPRINT 4 (Engagement)                                                                    
  ├─ 7. Notifications (SSE) ← RESEARCH NEEDED                                              
  ├─ 8. Moderation (Report system)                                                         
  └─ 10. Privacy Settings                                                                  
                                                                                           
  ---                                                                                      
  🚀 NEXT IMMEDIATE ACTIONS                                                                
                                                                                           
  Để tiến hành ngay, bạn cần:                                                              
                                                                                           
  Tuần này (Giai đoạn 1):                                                                  
                                                                                           
  1. Nghiên cứu News Feed Algorithm (1-2 ngày)                                             
    - Dùng NotebookLM query thêm                                                           
    - Đọc case studies: Reddit, HN, DEV.to                                                 
    - Chọn 1 algorithm + lý do                                                             
  2. Tạo User Personas (0.5 ngày)                                                          
    - Developer persona                                                                    
    - Student persona                                                                      
    - Tech learner persona                                                                 
  3. Viết User Stories chi tiết (1 ngày)                                                   
    - Break down 10 epics thành stories                                                    
    - Với Acceptance Criteria cụ thể                                                       
  4. Design Database Schema (1 ngày)                                                       
    - Chi tiết 9 collections                                                               
    - Indexes cho performance                                                              
    - Relationships                                                                        
  5. Setup Project (0.5 ngày)                                                              
    - Init Next.js + Payload                                                               
    - Configure MongoDB Atlas                                                              
    - Setup Vercel project                                                                 
                                                                                           
  ---