part of 'resource_bloc.dart';

@immutable
sealed class ResourceState {}

final class ResourceInitial extends ResourceState {}

final class ResourceLoading extends ResourceState {}

final class ResourceFailure extends ResourceState {
  final String error;
  ResourceFailure(this.error);
}

final class ResourceUploadSuccess extends ResourceState {
}

final class ResourceDisplaySuccess extends ResourceState {
  final List<ResourcePost> resources;
  ResourceDisplaySuccess(this.resources);
}


