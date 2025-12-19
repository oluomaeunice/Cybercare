import 'dart:io';

import 'package:cybercare/features/resources/data/resourcemodel/resource_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cybercare/core/error/exceptions.dart';

abstract interface class ResourceRemoteDataSource{
  Future<ResourceModel> uploadResource(ResourceModel resources);
  Future<String> uploadResourceImage({required File image, required ResourceModel resources});
  Future<String> uploadResourcePdf({required File pdf, required ResourceModel resources});
  Future<List<ResourceModel>> getAllResource();
}

class  ResourceRemoteDataSourceImplementation implements ResourceRemoteDataSource{
  final SupabaseClient supabaseClient;
  ResourceRemoteDataSourceImplementation(this.supabaseClient);

  @override
  Future<String> uploadResourceImage({required File image, required ResourceModel resources}) async {
    try {
      await supabaseClient.storage.from('resources').upload(
        'images/${resources.id}.jpg',
        image,
      );
      return supabaseClient.storage.from('resources').getPublicUrl('images/${resources.id}.jpg');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ResourceModel> uploadResource(ResourceModel resource) async {
    try {
      final resourceData = await supabaseClient.from('resources').insert(resource.toJson()).select();
      return ResourceModel.fromJson(resourceData.first);
    }on PostgrestException catch(e){
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ResourceModel>> getAllResource() async{
    try{
      final resources = await supabaseClient
          .from('resources')
          .select()
          .order('created_at', ascending: false);
      return resources
          .map((resource) => ResourceModel.fromJson(resource))
          .toList();

    }on PostgrestException catch(e){
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadResourcePdf({required File pdf, required ResourceModel resources}) async {
    try {
      // Store in a 'pdfs' folder inside the bucket
      await supabaseClient.storage.from('resources').upload(
        'pdfs/${resources.id}.pdf',
        pdf,
      );

      return supabaseClient.storage
          .from('resources')
          .getPublicUrl('pdfs/${resources.id}.pdf');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}