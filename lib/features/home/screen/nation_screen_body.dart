import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit/nation_cubit.dart';

class NationScreen extends StatelessWidget {
  const NationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Quốc Gia')),
      body: BlocBuilder<NationCubit, NationState>(
        builder: (context, state) {
          if (state is NationLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is NationLoaded) {
            return ListView.builder(
              itemCount: state.nations.length + 1, // Thêm 1 cho nút "Tải thêm"
              itemBuilder: (context, index) {
                if (index < state.nations.length) {
                  final nation = state.nations[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ✅ Ảnh đặt phía trên
                        Image.network(
                          nation.flagUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        // ✅ Thông tin quốc gia
                        Text(
                          nation.commonName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          nation.officialName,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else {
                  // ✅ Nút tải thêm dữ liệu (5 quốc gia mỗi lần)
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<NationCubit>().loadNations();
                      },
                      child: const Text('Tải thêm dữ liệu'),
                    ),
                  );
                }
              },
            );
          } 
          else if (state is NationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.read<NationCubit>().loadNations(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } 
          else {
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }
}
