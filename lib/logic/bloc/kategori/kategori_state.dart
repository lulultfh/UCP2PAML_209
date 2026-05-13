import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/kategori_models.dart';

abstract class KategoriState extends Equatable{
  @override
  List<Object?> get props => [];
}

class KategoriInitial extends KategoriState{}
class KategoriLoading extends KategoriState{}

class KategoriLoaded extends KategoriState{
  final List<KategoriModels> kategoriList;
  KategoriLoaded(this.kategoriList);
  @override
  List<Object> get props => [kategoriList];
}

class KategoriError extends KategoriState{
  final String message;
  KategoriError(this.message);
}

class KategoriCreatedSuccess extends KategoriState{}