import 'dart:io';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:cybercare/features/resources/domain/usecase/get_all_resources.dart';
import 'package:cybercare/features/resources/domain/usecase/upload_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final UploadResource _uploadResource;
  final GetAllResources _getAllResources;

  ResourceBloc({required UploadResource uploadResource, required GetAllResources getAllResources}) : _uploadResource = uploadResource, _getAllResources = getAllResources ,super(ResourceInitial()) {
    on<ResourceEvent>((event, emit)  => emit(ResourceLoading()));
    on<ResourceUploadEvent>(_onResourceUpload);
    on<FetchAllResources>(_onFetchAllResources);
  }

  void _onResourceUpload(ResourceUploadEvent event, Emitter<ResourceState> emit) async {
    final result = await _uploadResource(
      UploadResourceParams(
        image: event.image,
        title: event.title,
        description: event.description, // Added
        content: event.content,
        type: event.type,
        pdfFile: event.pdfFile,// Added (e.g. 'article' or 'pdf')
      ),
    );

    result.fold(
          (l) => emit(ResourceFailure(l.message)),
          (r) => emit(ResourceUploadSuccess()),
    );
  }

  void _onFetchAllResources(FetchAllResources event, Emitter<ResourceState> emit) async{
    final result = await _getAllResources(NoParams());
    result.fold((l) => emit(ResourceFailure(l.message)), (r) => emit(ResourceDisplaySuccess(r)));
  }
}
