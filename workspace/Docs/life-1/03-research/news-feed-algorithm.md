# News Feed Ranking Algorithm Research

> **Mục đích:** Document nghiên cứu thuật toán ranking cho News Feed  
> **Nguồn:** NotebookLM research, arhitacture-V2.md  
> **Query NotebookLM:** `python3 scripts/run.py ask_question.py --question "News Feed ranking algorithm" --notebook-url "[URL]"`  

---

## Các thuật toán phổ biến

### C) Time-decay + Engagement (Simple)
- `score = (likes + comments*2 + shares*3) / age_weight`
- `age_weight = 1 + (hours_since_post / 24)`
- Pros: Dễ implement, customize được
- Cons: Cần tune parameters

## Thuật toán đã chọn

**Đề xuất: Option C (Time-decay + Engagement)**

Lý do:
- Đơn giản implement
- Customize được weights (like=1, comment=2, share=3)
- Phù hợp social network content-centric
- Có thể tune age_weight theo thời gian (24h, 48h, ...)

## Implementation notes

- **Engagement score:** `likesCount + commentsCount*2 + sharesCount*3`
- **Age weight:** `1 + (hoursSincePost / 24)` — tăng dần theo thời gian → score cũ giảm
- **Final score:** `engagementScore / ageWeight`
- **Sort:** `{ rankingScore: -1, createdAt: -1 }`
- **Precompute:** Cập nhật `rankingScore` khi có like/comment/share (hoặc cron job)
