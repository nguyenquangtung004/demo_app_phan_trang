### Giải thích:
1. Chức Năng Chính Của Hàm _buildNationList()
- Hiển thị danh sách các quốc gia.
- Hỗ trợ lazy loading (cuộn và tải thêm dữ liệu).
- Nếu còn dữ liệu (hasMore = true), hiển thị thêm dòng "Đang tải thêm dữ liệu...".
-----
1. Khai Báo Hàm: 
   `Widget _buildNationList(List<dynamic> nations, bool hasMore)`
- List<dynamic> nations:
  * Danh sách quốc gia (dữ liệu hiển thị trên UI).
- bool hasMore:
  * Biến cờ xác định còn dữ liệu để tải hay không
2. ListView.builder - Tạo Danh Sách Cuộn Động:
```markdown
return ListView.builder(
  controller: _scrollController,
  itemCount: nations.length + (hasMore ? 1 : 0),
  itemBuilder: (context, index) {
    // Nội dung hiển thị
  },
)
```
- ListView.builder: Tạo danh sách cuộn động.
- controller: _scrollController:
  * Điều khiển trạng thái cuộn (được khai báo trước đó).
- itemCount: nations.length + (hasMore ? 1 : 0):
  * Nếu còn dữ liệu (hasMore = true), thêm 1 item phụ để hiển thị "Đang tải thêm dữ liệu...".
  * Nếu không (hasMore = false), chỉ hiển thị danh sách hiện tại.
3.  itemBuilder: Xử Lý Từng Phần Tử
   ```markdown
   itemBuilder: (context, index) {
  if (index < nations.length) {
    final nation = nations[index];
    return _buildNationCard(nation);
  } else {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text('Đang tải thêm dữ liệu...'),
      ),
    );
  }
}
   ```    
1. Khi index < nations.length:
    - Nếu index còn trong phạm vi của danh sách nations:
        * Lấy dữ liệu nation từ danh sách.
        * Hiển thị từng quốc gia bằng widget _buildNationCard(nation).
2. Khi index == nations.length (Cuộn Đến Cuối):
    - Nếu cuộn đến cuối và còn dữ liệu để tải (hasMore):
        * Hiển thị dòng "Đang tải thêm dữ liệu..." để báo hiệu đang thực hiện lazy loading.
3. Giải Thích hasMore và itemCount:
    `itemCount: nations.length + (hasMore ? 1 : 0)`
    - Nếu còn dữ liệu (hasMore = true):
        * Thêm 1 item phụ để hiển thị "Đang tải thêm dữ liệu...".
    - Nếu hết dữ liệu (hasMore = false):
        * Chỉ hiển thị danh sách hiện tại (nations.length).


