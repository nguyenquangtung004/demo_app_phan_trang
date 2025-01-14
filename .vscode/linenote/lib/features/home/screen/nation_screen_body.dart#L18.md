### 📌Giải thích
**❓Vì sao late được khai báo ScrollController ?**
1. Khai báo late ở đây vì ScrollController chỉ được khởi tạo sau widget nhưng khai báo thế này nghĩa là biến được khai báo nhưng chưa khởi tạo
----------
**❓Khi nào dùng late ?** 
1. Khi biến không thể khởi tạo ngay lập tức (ví dụ như ScrollController).
2. Khi cần khởi tạo trong initState().
3. Đảm bảo rằng biến luôn được khởi tạo trước khi sử dụng.