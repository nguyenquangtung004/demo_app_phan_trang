### 📌Giải thích
Mục đích: 
1. Dòng super.initState() gọi đến phương thức initState() của lớp cha (State).
2. Giúp đảm bảo hệ thống widget khởi tạo đầy đủ trước khi bạn thêm bất kỳ logic nào khác.
------
### 📌Liên tưởng:
**Vòng đời Android  -> 1. onCreate() -> 2. onStart() -> 3. onResume() -> 4. onPause() -> 5. onStop() -> 6. onDestroy() -> 7. onRestart()**
1. initState() - onCreate()
2. build() - onStart() và onResume()
3. dispose() - 	onDestroy()
------
`_scrollController = ScrollController()..addListener(_onScroll)`
1. ScrollController là một đối tượng trong Flutter để:
    - Theo dõi trạng thái cuộn của danh sách.
    - Điều khiển cuộn thủ công (ví dụ: tự động cuộn tới một vị trí cụ thể).
2. Được khởi tạo trong initState() để đảm bảo chỉ được tạo một lần duy nhất khi widget khởi tạo.
3. Cascade Operator(..) 
   - Được sử dụng để gọi phương thức addListener() ngay sau khi khởi tạo ScrollController.
4.  addListener(_onScroll):
    - Gắn một listener để theo dõi sự kiện cuộn.
    - Khi người dùng cuộn danh sách, phương thức _onScroll() sẽ được gọi.

**❓Vậy khi nào (..) dùng cái này ?**
1. Khi cần thực hiện nhiều thao tác trên cùng một đối tượng.
2.  Khi cần tạo và khởi tạo đối tượng một cách ngắn gọn.
3.  Tránh việc gọi lại đối tượng nhiều lần.
    - Ví dụ :   
   ```markdown
    @override
        void initState() {
            super.initState();
            _scrollController = ScrollController();
            _scrollController.addListener(_onScroll); // Không dùng cascade
        }
   ```
------