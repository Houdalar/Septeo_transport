import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import 'mocks.mocks.dart';

void main() {
  group('userServices -', () {
    late MockApiService mockApiService;
    late MockSessionManager mockSessionManager;
    late UserViewModel userViewModel;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockApiService = MockApiService();
      mockSessionManager = MockSessionManager();
      mockBuildContext = MockBuildContext();

      // Stubbing getUserId method
      when(mockSessionManager.getUserId()).thenAnswer((_) async => "64c8d38c55578bd4fbad84d8");

      // Stubbing findAncestorStateOfType method for navigator
      when(mockBuildContext.findAncestorStateOfType()).thenReturn(null);

      userViewModel = UserViewModel(
        apiService: mockApiService,
        sessionManager: mockSessionManager,
      );
    });

    test('login success', () async {
      // Arrange
      when(mockApiService.post("/login", {
        'email': 'admin@example.com',
        'password': 'adminPassword',
        'registrationToken': 'YOUR_NOTIFICATION_TOKEN'
      })).thenAnswer((_) async => {
        "token": "eX7NdulCSU-JYR-Z_V-GUR:APA91bGet8nLYb8O7_qxAKgshDUsZ2PahwBjDsO83WqjG7rVQhVBebPuFIn1YNXTM5bClQ55udC5fWPrdSNlEy6Yd8Aq5cozC8UC19g4yCUbhl_Q_TPGnGZQ--OjJ8Fl24goqqUyVoWs"
      });

      when(mockSessionManager.saveUserId(argThat(isNotNull))).thenAnswer((_) async => {});

      // Act
      await userViewModel.login(
        "admin@example.com",
        "adminPassword",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0YzhkMzhjNTU1NzhiZDRmYmFkODRkOCIsInJvbGUiOiJBZG1pbiIsImVtYWlsIjoiYWRtaW5AZXhhbXBsZS5jb20iLCJ1c2VybmFtZSI6ImFkbWluIiwiaWF0IjoxNjkyODcwODI2fQ.otXp3sIc6wPFVhoWxgTkMZMxUFqUYVxpaFCJ0S92GMU",
        mockBuildContext,
      );

      // Assert
      verify(mockSessionManager.saveUserId(argThat(isNotNull))).called(1);
      verify(mockSessionManager.getUserId()).called(1);
      verify(mockSessionManager.saveRole(argThat(isNotNull))).called(1);
    });
  });
}