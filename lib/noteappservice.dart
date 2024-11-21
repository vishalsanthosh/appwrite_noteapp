import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;

  late Databases databases;

  static const endpoint = 'https://cloud.appwrite.io/v1';
  static const projectId = '673ed23e0026d4625bcd';
  static const databaseId = '673ed29500184a00835f';
  static const collectionId = '673ed2a700353e060511';

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getNotes() async {
    try {
      final result = await databases.listDocuments(
        collectionId: collectionId,
        databaseId: databaseId,
      );
      return result.documents;
    } catch (e) {
      print('Error loading tasks: $e');
      rethrow;
    }
  }

 
  Future<Document> addNote(String title,String subtitle,String category,String date) async {
    try {
      final documentId = ID.unique(); 

      final result = await databases.createDocument(
        collectionId: collectionId,
        databaseId: databaseId,
        data: {
          'title': title,
          'subtitle':subtitle,
          'category':category,
          'date':date,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String documentId) async {
    try {
      await databases.deleteDocument(
        collectionId: collectionId,
        documentId: documentId,
        databaseId: databaseId,
      );
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}