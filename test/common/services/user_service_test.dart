// test/features/auth/services/user_service_test.dart
import 'package:boilerplate_template/common/user/models/user_model.dart';
import 'package:boilerplate_template/common/user/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import the generated mocks
import 'user_service_test.mocks.dart';

// Generate mocks for FirebaseFirestore and related generic classes
@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(),
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late UserService userService;

  // Common test data
  const testUid = 'user123';
  const testEmail = 'test@example.com';
  const testPhoneNumber = '+1234567890';
  final testUserModel = UserModel(
    id: testUid,
    email: testEmail,
    phoneNumber: testPhoneNumber,
    createdAt: DateTime.now(),
  );

  setUp(() {
    // Instantiate the mocks
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();

    // When firestore.collection('users') is called, return mockCollection
    when(mockFirestore.collection('users')).thenReturn(mockCollection);

    // When mockCollection.doc(testUid) is called, return mockDocument
    when(mockCollection.doc(testUid)).thenReturn(mockDocument);

    userService = UserService(firebaseFirestore: mockFirestore);
  });

  group('UserService - createUser', () {
    test('createUser successfully creates a user in Firestore', () async {
      // Arrange
      when(mockDocument.set(testUserModel.toJson()))
          .thenAnswer((_) async => Future.value());

      // Act
      await userService.createUser(testUserModel);

      // Assert
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.set(testUserModel.toJson())).called(1);
    });

    test('createUser throws an exception when Firestore set fails', () async {
      // Arrange
      when(mockDocument.set(testUserModel.toJson()))
          .thenThrow(FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Failed to write to Firestore',
        code: 'unknown',
      ));

      // Act & Assert
      expect(() => userService.createUser(testUserModel),
          throwsA(isA<FirebaseException>()));

      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.set(testUserModel.toJson())).called(1);
    });
  });

  group('UserService - getUser', () {
    test('getUser returns UserModel when user exists', () async {
      // Arrange
      when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({
        'id': testUid,
        'email': testEmail,
        'phoneNumber': testPhoneNumber,
        'createdAt': Timestamp.fromDate(testUserModel.createdAt!),
      });

      // Act
      final result = await userService.getUser(testUid);

      // Assert
      expect(result, isA<UserModel>());
      expect(result?.id, testUid);
      expect(result?.email, testEmail);
      expect(result?.phoneNumber, testPhoneNumber);
      expect(result?.createdAt, testUserModel.createdAt);
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.get()).called(1);
    });

    test('getUser returns null when user does not exist', () async {
      // Arrange
      when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      // Act
      final result = await userService.getUser(testUid);

      // Assert
      expect(result, isNull);
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.get()).called(1);
    });

    test('getUser throws an exception when Firestore get fails', () async {
      // Arrange
      when(mockDocument.get()).thenThrow(FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Failed to read from Firestore',
        code: 'unknown',
      ));

      // Act & Assert
      expect(() => userService.getUser(testUid),
          throwsA(isA<FirebaseException>()));

      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.get()).called(1);
    });

    test('getUser handles malformed data gracefully', () async {
      // Arrange
      when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({
        'id': testUid,
        'email': testEmail,
        // 'phoneNumber' is missing
        'createdAt': Timestamp.fromDate(testUserModel.createdAt!),
      });

      // Act
      final result = await userService.getUser(testUid);

      // Assert
      // Depending on your UserModel implementation, this might throw or handle missing fields
      // Assuming it can handle missing phoneNumber
      expect(result, isA<UserModel>());
      expect(result?.id, testUid);
      expect(result?.email, testEmail);
      expect(result?.phoneNumber, isNull);
      expect(result?.createdAt, testUserModel.createdAt);
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(testUid)).called(1);
      verify(mockDocument.get()).called(1);
    });
  });
}
