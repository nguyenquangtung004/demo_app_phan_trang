import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/data_source/nation_remote_data_source.dart';
import 'data/repository_impl/nation_repository_impl.dart';
import 'domain/usecases/get_nation.dart';
import 'features/home/bloc/cubit/nation_cubit.dart';
import 'features/home/screen/nation_screen_body.dart';

void main() async{
  final nationRepository = NationRepositoryImpl(
    remoteDataSource: NationRemoteDataSource(),
  );

  //   final dio = Dio(BaseOptions(baseUrl: 'https://restcountries.com/v3.1'));
  // try {
  //   final response = await dio.get('/all?offset=1&limit=5');
  //   print('✅ Kết nối API thành công: Nhận ${response.data.length} quốc gia.');
  // } catch (e) {
  //   print('❌ Không thể kết nối API: $e');
  // }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NationCubit(
            getNations: GetNations(repository: nationRepository),
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NationScreen(),
      ),
    ),
  );
}
