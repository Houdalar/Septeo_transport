import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:septeo_transport/model/planning.dart';
import 'package:septeo_transport/model/user.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import 'mocks.mocks.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockNavigator extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {Object? arguments,
      TO? result}) async {
    return null;
  }
}

void main() {
  group('userServices -', () {
    late MockApiService mockApiService;
    late MockSessionManager mockSessionManager;
    late UserViewModel userViewModel;
    late MockBuildContext mockBuildContext;
    late MockNavigator mockNavigator;

    setUp(() {
      mockApiService = MockApiService();
      mockSessionManager = MockSessionManager();
      mockBuildContext = MockBuildContext();
      mockNavigator = MockNavigator();

      // Stubbing getUserId method
      when(mockSessionManager.getUserId())
          .thenAnswer((_) async => "64e38969d09b5c426d9f0aaf");

      // Stubbing findAncestorStateOfType method for navigator
      when(mockBuildContext.findAncestorStateOfType<NavigatorState>())
          .thenReturn(mockNavigator);

      userViewModel = UserViewModel(
        apiService: mockApiService,
        sessionManager: mockSessionManager,
      );
    });

    /*test('login success', () async {
      when(mockApiService.post("/login", any)).thenAnswer((_) async => {
            "_id": "64e38969d09b5c426d9f0aaf",
            "email": "employee@example.com",
            "password":
                "\$2a\$10\$UZ.szFL.xI23OkixLi4P1uVTTczvnIAJ5WH0eZpmflRwTP3n3awEu",
            "username": "employee",
            "role": "Employee",
            "registrationToken": "",
            "__v": 0
          });
      when(mockSessionManager.saveUserId(any)).thenAnswer((_) async => {});
      when(mockSessionManager.getUserId())
          .thenAnswer((_) async => "64e38969d09b5c426d9f0aaf");

      // Act
      await userViewModel.login(
          "employee@example.com", "employeePassword", "", mockBuildContext);

      // Assert
      verify(mockSessionManager.saveUserId("64e38969d09b5c426d9f0aaf"))
          .called(1);
      verify(mockSessionManager.getUserId())
          .called(2); // Check if it's called once or twice
      verify(mockSessionManager.saveRole("Employee")).called(1);
      verify(mockNavigator.pushReplacementNamed('/home',
              arguments: Role.Employee))
          .called(1);
    });*/

    test('getDrivers returns a list of drivers', () async {
      when(mockApiService.get("/drivers")).thenAnswer((_) async => [
            {
              "_id": "64e38969d09b5c426d9f0ab2",
              "email": "driver1@example.com",
              "password":
                  "\$2a\$10\$yOwYQG3bJUbihVeOrvNtKOhYWtlTarfI2b/PAWFs2WQiZvZsa63oO",
              "username": "driver1",
              "role": "Driver",
              "registrationToken": "",
              "__v": 0
            },
            {
              "_id": "64e38969d09b5c426d9f0ab5",
              "email": "driver2@example.com",
              "password":
                  "\$2a\$10\$YWKUbgmeBqGIlm3NydsaoeAJGb6v/1P8I5BnffPp4teDQd7B8Wobq",
              "username": "driver2",
              "role": "Driver",
              "registrationToken": "",
              "__v": 0
            },
            {
              "_id": "64e38969d09b5c426d9f0ab8",
              "email": "driver3@example.com",
              "password":
                  "\$2a\$10\$WqCHORloW8GdTRE3TDa8.usYuYFULd1H7bWrHGMYLaUq.HD0GhqlO",
              "username": "driver3",
              "role": "Driver",
              "registrationToken": "",
              "__v": 0
            },
            {
              "_id": "64e38969d09b5c426d9f0abb",
              "email": "driver4@example.com",
              "password":
                  "\$2a\$10\$xEqN/KNetQfuyVc4PPw6o.jnaS.7AFq6LO7KOZgXhsgVOeyjjgLl.",
              "username": "driver4",
              "role": "Driver",
              "registrationToken": "",
              "__v": 0
            }
          ]);

      final drivers = await userViewModel.getDrivers();

      expect(drivers, isA<List<User>>());
      expect(drivers.first.email, "driver1@example.com");
    });

    test('get today s  planning for a user', () async {
      when(mockSessionManager.getUserId())
          .thenAnswer((_) async => "someUserId");
      when(mockApiService.get('/todayplanning/64e38969d09b5c426d9f0aaf'))
          .thenAnswer((_) async => {
                "_id": "64ea574b7fa739a17be5623d",
                "user": "64e38969d09b5c426d9f0aac",
                "date": "2023-08-26",
                "isTakingBus": true,
                "toStation": {
                  "location": {
                    "lat": 36.84667571657724,
                    "lng": 10.2832678089414
                  },
                  "_id": "64ea571f7fa739a17be56234",
                  "name": "mourouj2",
                  "address": "lac 2 , lac d'or",
                  "arrivaltime": [
                    {
                      "bus": {
                        "_id": "64ea56d97fa739a17be56220",
                        "capacity": 50,
                        "busNumber": "B24",
                        "__v": 0
                      },
                      "time": "07:25",
                      "_id": "64ea571f7fa739a17be56235"
                    },
                    {
                      "bus": {
                        "_id": "64ea56df7fa739a17be56222",
                        "capacity": 50,
                        "busNumber": "B23",
                        "__v": 0
                      },
                      "time": "17:45",
                      "_id": "64ea571f7fa739a17be56236"
                    },
                    {
                      "bus": {
                        "_id": "64ea56df7fa739a17be56222",
                        "capacity": 50,
                        "busNumber": "B23",
                        "__v": 0
                      },
                      "time": "07:30",
                      "_id": "64ea571f7fa739a17be56237"
                    },
                    {
                      "bus": {
                        "_id": "64ea56d97fa739a17be56220",
                        "capacity": 50,
                        "busNumber": "B24",
                        "__v": 0
                      },
                      "time": "17:50",
                      "_id": "64ea571f7fa739a17be56238"
                    }
                  ],
                  "__v": 0
                },
                "fromStation": {
                  "location": {
                    "lat": 36.84667571657724,
                    "lng": 10.2832678089414
                  },
                  "_id": "64ea571f7fa739a17be56234",
                  "name": "mourouj2",
                  "address": "lac 2 , lac d'or",
                  "arrivaltime": [
                    {
                      "bus": {
                        "_id": "64ea56d97fa739a17be56220",
                        "capacity": 50,
                        "busNumber": "B24",
                        "__v": 0
                      },
                      "time": "07:25",
                      "_id": "64ea571f7fa739a17be56235"
                    },
                    {
                      "bus": {
                        "_id": "64ea56df7fa739a17be56222",
                        "capacity": 50,
                        "busNumber": "B23",
                        "__v": 0
                      },
                      "time": "17:45",
                      "_id": "64ea571f7fa739a17be56236"
                    },
                    {
                      "bus": {
                        "_id": "64ea56df7fa739a17be56222",
                        "capacity": 50,
                        "busNumber": "B23",
                        "__v": 0
                      },
                      "time": "07:30",
                      "_id": "64ea571f7fa739a17be56237"
                    },
                    {
                      "bus": {
                        "_id": "64ea56d97fa739a17be56220",
                        "capacity": 50,
                        "busNumber": "B24",
                        "__v": 0
                      },
                      "time": "17:50",
                      "_id": "64ea571f7fa739a17be56238"
                    }
                  ],
                  "__v": 0
                },
                "finishbus": {
                  "_id": "64ea56df7fa739a17be56222",
                  "capacity": 50,
                  "busNumber": "B23",
                  "__v": 0
                },
                "startbus": {
                  "_id": "64ea56df7fa739a17be56222",
                  "capacity": 50,
                  "busNumber": "B23",
                  "__v": 0
                },
                "__v": 0
              });

      final planning = await userViewModel.getTodayPlanning();

      expect(planning, isA<Planning>());
    });

    /* test('addPlanning adds a planning and returns it', () async {
      final mockPlanningResponse = {
        "user": "64e38969d09b5c426d9f0aac",
        "date": "2023-08-28",
        "isTakingBus": false,
        "toStation": {
          "location": {"lat": 36.84667571657724, "lng": 10.2832678089414},
          "_id": "64ea571f7fa739a17be56234",
          "name": "mourouj2",
          "address": "lac 2 , lac d'or",
          "arrivaltime": [
            {
              "bus": {
                "_id": "64ea56d97fa739a17be56220",
                "capacity": 50,
                "busNumber": "B24",
                "__v": 0
              },
              "time": "07:25",
              "_id": "64ea571f7fa739a17be56235"
            },
            {
              "bus": {
                "_id": "64ea56df7fa739a17be56222",
                "capacity": 50,
                "busNumber": "B23",
                "__v": 0
              },
              "time": "17:45",
              "_id": "64ea571f7fa739a17be56236"
            },
            {
              "bus": {
                "_id": "64ea56df7fa739a17be56222",
                "capacity": 50,
                "busNumber": "B23",
                "__v": 0
              },
              "time": "07:30",
              "_id": "64ea571f7fa739a17be56237"
            },
            {
              "bus": {
                "_id": "64ea56d97fa739a17be56220",
                "capacity": 50,
                "busNumber": "B24",
                "__v": 0
              },
              "time": "17:50",
              "_id": "64ea571f7fa739a17be56238"
            }
          ],
          "__v": 0
        },
        "fromStation": {
          "location": {"lat": 36.84667571657724, "lng": 10.2832678089414},
          "_id": "64ea571f7fa739a17be56234",
          "name": "mourouj2",
          "address": "lac 2 , lac d'or",
          "arrivaltime": [
            {
              "bus": {
                "_id": "64ea56d97fa739a17be56220",
                "capacity": 50,
                "busNumber": "B24",
                "__v": 0
              },
              "time": "07:25",
              "_id": "64ea571f7fa739a17be56235"
            },
            {
              "bus": {
                "_id": "64ea56df7fa739a17be56222",
                "capacity": 50,
                "busNumber": "B23",
                "__v": 0
              },
              "time": "17:45",
              "_id": "64ea571f7fa739a17be56236"
            },
            {
              "bus": {
                "_id": "64ea56df7fa739a17be56222",
                "capacity": 50,
                "busNumber": "B23",
                "__v": 0
              },
              "time": "07:30",
              "_id": "64ea571f7fa739a17be56237"
            },
            {
              "bus": {
                "_id": "64ea56d97fa739a17be56220",
                "capacity": 50,
                "busNumber": "B24",
                "__v": 0
              },
              "time": "17:50",
              "_id": "64ea571f7fa739a17be56238"
            }
          ],
          "__v": 0
        },
        "finishbus": {
          "_id": "64ea56df7fa739a17be56222",
          "capacity": 50,
          "busNumber": "B23",
          "__v": 0
        },
        "startbus": {
          "_id": "64ea56df7fa739a17be56222",
          "capacity": 50,
          "busNumber": "B23",
          "__v": 0
        },
        "_id": "64eb253c589787fb92409f79",
        "__v": 0
      };

      when(mockApiService.post("/planning", any))
          .thenAnswer((_) async => mockPlanningResponse);

      final planning = await userViewModel.addPlanning(
        date: "2023-08-28T02:47:00.000Z",
        fromStation: "64ea571f7fa739a17be56234",
        toStation: "64ea571f7fa739a17be56234",
        startBus: "64ea56df7fa739a17be56222",
        finishBus: "64ea56df7fa739a17be56222",
      );

      expect(planning, isA<Planning>());
      expect(planning.id, "64ea571f7fa739a17be56234");
    });*/
  });
}
