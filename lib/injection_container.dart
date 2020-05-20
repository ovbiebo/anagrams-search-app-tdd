import 'package:anagramapp/features/anagram_finder/data/datasources/anagram_remote_data_source.dart';
import 'package:anagramapp/features/anagram_finder/data/repositories/anagram_repository_impl.dart';
import 'package:anagramapp/features/anagram_finder/domain/usecases/get_anagrams.dart';
import 'package:anagramapp/features/anagram_finder/presentation/bloc/anagrams_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/anagram_finder/domain/repositories/anagram_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(
    () => AnagramsBloc(
      getAnagrams: sl(),
    ),
  );

  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectionChecker: sl()),
  );

  sl.registerLazySingleton<AnagramRemoteDataSource>(
        () => AnagramRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AnagramRepository>(
    () => AnagramRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAnagrams(repository: sl()));

}
