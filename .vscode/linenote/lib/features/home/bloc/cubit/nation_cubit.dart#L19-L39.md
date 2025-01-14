### Giải thích
1. Chức Năng Chính Của Hàm loadNations()
   - Phương thức bất đồng bộ (async) để tải dữ liệu từ NationUseCase.
   - Quản lý trạng thái dữ liệu với Bloc State Management.
   - Cung cấp pagination logic (tải dữ liệu phân trang).
--------
1.  Kiểm Tra Nếu Không Còn Dữ Liệu Để Tải:
    ```markdown
    if (!getNations.hasMoreData) {
        emit(NationError("Không còn dữ liệu để tải."));
        return;
        }
    ```
- !getNations.hasMoreData:
  * Kiểm tra cờ hasMoreData từ GetNations Use Case.
  * Nếu false (không còn dữ liệu để tải):
    * Gọi emit(NationError) để thông báo lỗi.
    * return để kết thúc hàm ngay lập tức.
2. Phát State Loading (Giữ Dữ Liệu Cũ Nếu Có):
   ```markdown
   emit(NationLoading(state is NationLoaded ? (state as NationLoaded).nations : []));
   ```
- emit(NationLoading(...)):
  * Phát state NationLoading để UI hiển thị trạng thái loading.
- Giữ Dữ Liệu Cũ Nếu Có:
  * Nếu state hiện tại là NationLoaded: Giữ lại dữ liệu cũ (state.nations).
  * Nếu không, gửi một danh sách rỗng []
3.  Gọi UseCase Để Fetch Dữ Liệu:
    `final nations = await getNations.call();`
  - await getNations.call()
    * Gọi GetNations Use Case để fetch dữ liệu từ repository.
    * Hàm bất đồng bộ nên cần await để chờ dữ liệu trả về.
4.  Phát State Thành Công Nếu Có Dữ Liệu:
    `emit(NationLoaded(nations, hasMore: getNations.hasMoreData))`
  - emit(NationLoaded):
    * Phát state NationLoaded với danh sách quốc gia vừa tải được.
  - hasMore: getNations.hasMoreData
    * Cập nhật cờ hasMoreData để kiểm tra xem còn dữ liệu không.
5.  Xử Lý Lỗi Nếu Gặp Sự Cố
--------
**❓Tại Sao Dùng if (!getNations.hasMoreData) Ở Đầu Hàm?**
- Để ngăn chặn việc gọi API thừa thãi khi đã hết dữ liệu.
- Tránh việc tải lại dữ liệu không cần thiết.
