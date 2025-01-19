import 'package:boilerplate_template/common/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/common/user/models/user_model.dart';
import 'package:boilerplate_template/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks with Mockito
@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<IUserService>(),
  MockSpec<User>(),
  MockSpec<UserCredential>(),
  MockSpec<PhoneAuthCredential>(),
  MockSpec<AuthCredential>(),
])
import 'auth_service_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockIUserService mockUserService;
  late AuthService authService;

  // Common test data
  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUid = 'user123';
  const testPhoneNumber = '+1234567890';
  const testVerificationId = 'verification_id_123';
  const testSmsCode = '123456';

  // Common mock objects
  late MockUser testUser;
  late MockUserCredential testUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserService = MockIUserService();
    authService = AuthService(mockUserService, firebaseAuth: mockFirebaseAuth);

    testUser = MockUser();
    testUserCredential = MockUserCredential();

    // Common user setup
    when(testUser.uid).thenReturn(testUid);
    when(testUser.email).thenReturn(testEmail);
    when(testUser.phoneNumber).thenReturn(testPhoneNumber);
    when(testUserCredential.user).thenReturn(testUser);
  });

  group('AuthService - Email & Password Authentication', () {
    late UserModel testUserModel;

    setUp(() {
      testUserModel = UserModel(id: testUid, email: testEmail);
    });

    test('signInWithEmailAndPassword returns UserModel on success', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => testUserCredential);

      when(mockUserService.getUser(testUid))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result =
          await authService.signInWithEmailAndPassword(testEmail, testPassword);

      // Assert
      expect(result, isA<UserModel>());
      expect(result?.email, testEmail);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
      verify(mockUserService.getUser(testUid)).called(1);
    });

    test('registerWithEmailAndPassword returns UserModel on success', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => testUserCredential);

      when(mockUserService.getUser(testUid))
          .thenAnswer((_) async => null); // User doesn't exist

      when(mockUserService.createUser(any)).thenAnswer((_) async {});

      // Act
      final result = await authService.registerWithEmailAndPassword(
          testEmail, testPassword);

      // Assert
      expect(result, isA<UserModel>());
      expect(result?.email, testEmail);
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
      verify(mockUserService.getUser(testUid)).called(1);
      verify(mockUserService.createUser(any)).called(1);
    });

    test(
        'signInWithEmailAndPassword throws FirebaseAuthException on wrong password',
        () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act & Assert
      await expectLater(
          () => authService.signInWithEmailAndPassword(testEmail, testPassword),
          throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
      verifyNever(mockUserService.getUser(any));
    });

    test(
        'registerWithEmailAndPassword throws FirebaseAuthException on email in use',
        () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act & Assert
      await expectLater(
          () =>
              authService.registerWithEmailAndPassword(testEmail, testPassword),
          throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
      verifyNever(mockUserService.getUser(any));
      verifyNever(mockUserService.createUser(any));
    });
  });

  group('AuthService - Phone Number Authentication', () {
    late UserModel testUserModel;

    setUp(() {
      testUserModel = UserModel(id: testUid, phoneNumber: testPhoneNumber);
    });

    test('verifyPhoneNumber calls FirebaseAuth.verifyPhoneNumber', () async {
      // Arrange
      when(mockFirebaseAuth.verifyPhoneNumber(
        phoneNumber: anyNamed('phoneNumber'),
        verificationCompleted: anyNamed('verificationCompleted'),
        verificationFailed: anyNamed('verificationFailed'),
        codeSent: anyNamed('codeSent'),
        codeAutoRetrievalTimeout: anyNamed('codeAutoRetrievalTimeout'),
        timeout: anyNamed('timeout'),
      )).thenAnswer((Invocation invocation) async {
        final PhoneCodeSent codeSent =
            invocation.namedArguments[const Symbol('codeSent')];
        // Simulate code sent callback
        codeSent(testVerificationId, null);
      });

      // Act
      await authService.verifyPhoneNumber(
        testPhoneNumber,
        codeSent: (verId) {},
        verificationFailed: (error) {},
      );

      // Assert
      verify(mockFirebaseAuth.verifyPhoneNumber(
        phoneNumber: testPhoneNumber,
        verificationCompleted: anyNamed('verificationCompleted'),
        verificationFailed: anyNamed('verificationFailed'),
        codeSent: anyNamed('codeSent'),
        codeAutoRetrievalTimeout: anyNamed('codeAutoRetrievalTimeout'),
        timeout: anyNamed('timeout'),
      )).called(1);
    });

    test('signInWithSmsCode returns UserModel on success', () async {
      // Arrange
      authService.verificationId = testVerificationId;

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => testUserCredential);

      when(mockUserService.getUser(testUid))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await authService.signInWithSmsCode(testSmsCode);

      // Assert
      expect(result, isA<UserModel>());
      expect(result?.phoneNumber, testPhoneNumber);
      verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      verify(mockUserService.getUser(testUid)).called(1);
    });

    test('signInWithSmsCode throws Exception if verificationId is null',
        () async {
      // Arrange
      authService.verificationId = null;

      // Act & Assert
      await expectLater(() => authService.signInWithSmsCode(testSmsCode),
          throwsA(isA<Exception>()));

      verifyNever(mockFirebaseAuth.signInWithCredential(any));
      verifyNever(mockUserService.getUser(any));
    });

    test('signInWithSmsCode throws FirebaseAuthException on invalid SMS code',
        () async {
      // Arrange
      authService.verificationId = testVerificationId;

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenThrow(FirebaseAuthException(code: 'invalid-verification-code'));

      // Act & Assert
      await expectLater(() => authService.signInWithSmsCode(testSmsCode),
          throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      verifyNever(mockUserService.getUser(any));
    });
  });

  group('AuthService - Auth State Changes', () {
    late UserModel testUserModel;

    setUp(() {
      testUserModel = UserModel(id: testUid, email: 'test@example.com');
    });

    test('authStateChanges emits UserModel when user is signed in', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(testUser));

      when(mockUserService.getUser(testUid))
          .thenAnswer((_) async => testUserModel);

      // Act
      final authStateStream = authService.authStateChanges;
      final result = await authStateStream.first;

      // Assert
      expect(result, isA<UserModel>());
      expect(result?.email, 'test@example.com');
      verify(mockUserService.getUser(testUid)).called(1);
    });

    test('authStateChanges emits null when user is signed out', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      // Act
      final authStateStream = authService.authStateChanges;
      final result = await authStateStream.first;

      // Assert
      expect(result, isNull);
      verifyNever(mockUserService.getUser(any));
    });
  });

  group('AuthService - Sign Out', () {
    test('signOut calls FirebaseAuth.signOut', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      await authService.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('signOut throws FirebaseAuthException if signOut fails', () async {
      // Arrange
      when(mockFirebaseAuth.signOut())
          .thenThrow(FirebaseAuthException(code: 'sign-out-failed'));

      // Act & Assert
      await expectLater(
          () => authService.signOut(), throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('AuthService - Error Handling', () {
    test(
        'signInWithEmailAndPassword throws FirebaseAuthException when user not found',
        () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act & Assert
      await expectLater(
          () => authService.signInWithEmailAndPassword(testEmail, testPassword),
          throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
    });

    test(
        'registerWithEmailAndPassword throws FirebaseAuthException on email in use',
        () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act & Assert
      await expectLater(
          () =>
              authService.registerWithEmailAndPassword(testEmail, testPassword),
          throwsA(isA<FirebaseAuthException>()));

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .called(1);
    });
  });
}
