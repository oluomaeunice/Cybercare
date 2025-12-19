import 'dart:io';

import 'package:cybercare/core/error/exceptions.dart';
import 'package:cybercare/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();

  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    File? imageFile,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImplementation(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;


  @override
  Future<UserModel?> getCurrentUserData() async{
    try{
      if (currentUserSession!=null) {
        final userData = await supabaseClient.from('profiles').select().eq('id', currentUserSession!.user.id);
        
        return UserModel.fromJson(userData.first).copyWith(email: currentUserSession!.user.email);
      }
      return null;
    }catch(e){
      throw ServerException(e.toString());
    }
  }


  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async{
    try{
      final response = await supabaseClient.auth.signUp(password: password, email: email, data: {'name':name});
      if(response.user == null){
        throw ServerException('user is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    }  on AuthException catch(e){
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async{
    try{
      final response = await supabaseClient.auth.signInWithPassword(password: password, email: email,);
      if(response.user == null){
        throw ServerException('user is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    }  on AuthException catch(e){
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;

      // 1. Upload Image if provided
      if (imageFile != null) {
        final imagePath = '$userId/profile.jpg';

        // Upsert allows overwriting existing file
        await supabaseClient.storage.from('avatars').upload(
          imagePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

        imageUrl = supabaseClient.storage.from('avatars').getPublicUrl(imagePath);
      }

      // 2. Prepare Update Data
      final updates = {
        'name': name,
        'updated_at': DateTime.now().toIso8601String(),
        if (imageUrl != null) 'avatar_url': imageUrl,
      };

      // 3. Update Profile Table
      final response = await supabaseClient
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      // 4. Return updated model (merge with current session email)
      return UserModel.fromJson(response).copyWith(
        email: currentUserSession?.user.email,
      );

    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
