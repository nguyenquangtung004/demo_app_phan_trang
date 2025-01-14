### Giải thích :
1. Chức Năng Chính Của Hàm:
   - Hàm _onRefresh() được sử dụng để:
     * Làm mới dữ liệu khi người dùng kéo từ đầu danh sách xuống dưới (Pull-to-Refresh).
     * Gọi Cubit để reset lại dữ liệu và tải lại từ đầu.
2. Khai Báo Hàm Async:
   `Future<void> _onRefresh() async {`
   - Future<void>:
     * Hàm trả về một Future nhưng không có giá trị (void).
     * Được sử dụng vì việc tải lại dữ liệu là một quá trình bất đồng bộ (async).
3. Truy Cập Cubit Từ context:
   `context.read<NationCubit>().resetPagination();`
     * Truy cập trực tiếp đến NationCubit trong cây widget hiện tại.
     * Điều kiện: Phải có BlocProvider được bọc ngoài NationScreen.
4. Gọi Hàm resetPagination() Từ Cubit:`resetPagination();`
### Quy trình hoạt động
   - Người dùng kéo xuống từ đầu trang.
   - _onRefresh() được gọi.
   - Cubit: resetPagination()
    * Đặt lại offset và trạng thái loading.
   - Gọi API để tải lại dữ liệu.
   - Dữ liệu được tải xong: Hiển thị danh sách mới.
