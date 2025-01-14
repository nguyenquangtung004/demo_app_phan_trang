import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/cubit/nation_cubit.dart';
import '../bloc/cubit/nation_state.dart';

/// ANCHOR: NationScreen - Màn hình chính hiển thị danh sách quốc gia
class NationScreen extends StatefulWidget {
  const NationScreen({super.key});

  @override
  State<NationScreen> createState() => _NationScreenState();
}

/// SECTION: State quản lý logic cuộn và tải dữ liệu
class _NationScreenState extends State<NationScreen> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false; // Cờ kiểm tra trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  /// SECTION: Cuộn tới cuối danh sách để tải thêm dữ liệu
  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      await Future.delayed(const Duration(seconds: 1)); 
      context.read<NationCubit>().loadNations();
      setState(() => _isLoadingMore = false);
    }
  }

  /// SECTION: Kéo từ đầu trang để làm mới dữ liệu
  Future<void> _onRefresh() async {
    context.read<NationCubit>().resetPagination();
  }

  /// ANCHOR: Build chính của Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Quốc Gia')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<NationCubit, NationState>(
          builder: (context, state) {
            // SECTION: Loading lần đầu - Hiển thị Shimmer
            if (state is NationLoading && state.nations.isEmpty) {
              return _buildLoadingShimmer();
            }

            // SECTION: Đã load dữ liệu thành công
            if (state is NationLoaded) {
              return _buildNationList(state.nations, state.hasMore);
            }

            // SECTION: Xử lý lỗi
            if (state is NationError) {
              return _buildErrorState(state.message);
            }

            // SECTION: Trạng thái mặc định
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// SECTION: Danh sách quốc gia
  Widget _buildNationList(List<dynamic> nations, bool hasMore) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: nations.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < nations.length) {
          final nation = nations[index];
          return _buildNationCard(nation);
        } else {
          // ANCHOR: Hiển thị "Đang tải thêm dữ liệu..." khi cuộn đến cuối
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('Đang tải thêm dữ liệu...'),
            ),
          );
        }
      },
    );
  }

  /// SECTION: Shimmer khi loading lần đầu
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const ShimmerCard(),
    );
  }

  /// SECTION: Card hiển thị thông tin quốc gia
  Widget _buildNationCard(nation) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            nation.flagUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Text(nation.commonName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(nation.officialName, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// SECTION: Hiển thị trạng thái lỗi
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<NationCubit>().loadNations(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

/// ✅ Widget ShimmerCard cho hiệu ứng loading
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 20, width: 120, color: Colors.grey),
            const SizedBox(height: 5),
            Container(height: 20, width: 150, color: Colors.grey),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
