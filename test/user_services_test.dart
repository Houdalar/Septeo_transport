import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import 'mocks.dart';

void main() {
  group('UserViewModel -', () {
    late MockApiService mockApiService;
    late MockSessionManager mockSessionManager;
    late UserViewModel userViewModel;

    setUp(() {
      mockApiService = MockApiService();
      mockSessionManager = MockSessionManager();
      userViewModel = UserViewModel(
        apiService: mockApiService,
        sessionManager: mockSessionManager,
      );
    });

    test('login success', () async {
      // Arrange
      when(mockApiService.post("/login", anyOrNull))
    .thenAnswer((_) async => {
  "token": "your_sample_jwt_token"
});
      when(mockSessionManager.saveUserId(any)).thenAnswer((_) async => {});
      when(mockSessionManager.getUserId()).thenAnswer((_) async => "sample_user_id");
      when(mockSessionManager.saveRole(any)).thenAnswer((_) async => {});

      // Act
      await userViewModel.login("test@email.com", "password123", "registrationToken", /* context */);

      // Assert
      verify(mockSessionManager.saveUserId()).called(1);
      verify(mockSessionManager.getUserId()).called(1);
      verify(mockSessionManager.saveRole(any)).called(1);
      // Add more assertions as needed
    });
  });
}