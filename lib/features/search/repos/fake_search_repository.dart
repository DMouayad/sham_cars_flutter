part of '../repositories.dart';

final class FakeSearchRepository extends SearchRepository {
  @override
  List<SearchResult> _decodeResponseBody(JsonObject json) {
    List<SearchResult> results = [];
    if (json
        case {
          "facilities": List<JsonObject> facilitiesJson,
          "physicians": List<JsonObject> physiciansJson,
        }) {
      for (var physicianJson in physiciansJson) {
        if (physicianJson
            case {
              'id': String id,
              'name': String name,
              'location': String location,
              'biography': String biography,
              'dateOfBirth': String dateOfBirth,
              'isMale': bool isMale,
              'languages': Iterable<String> languages,
              'specialties': List<String> specialties,
              'phoneNumber': String phoneNumber,
              'mobilePhoneNumber': String mobilePhoneNumber,
              'rating': double rating
            }) {
          results.add(
            SearchResult.physician(Physician(
              id: id,
              name: name,
              mobilePhoneNumber: mobilePhoneNumber,
              phoneNumber: phoneNumber,
              biography: biography,
              specialties: specialties,
              location: location,
              isMale: isMale,
              dateOfBirth: DateTime.tryParse(dateOfBirth),
              languages: languages.toList(),
              rating: rating,
            )),
          );
        }
      }
      for (var facilityJson in facilitiesJson) {
        if (facilityJson
            case {
              'id': String id,
              'name': String name,
              'location': String location,
              'emergencyPhoneNumber': String emergencyPhoneNumber,
              'mobilePhoneNumber': String mobilePhoneNumber,
              'phoneNumber': String phoneNumber,
              'description': String description,
              'rating': double rating
            }) {
          results.add(SearchResult.facility(MedicalFacility(
            id: id,
            name: name,
            description: description,
            emergencyPhoneNumber: emergencyPhoneNumber,
            mobilePhoneNumber: mobilePhoneNumber,
            phoneNumber: phoneNumber,
            location: location,
            rating: rating,
          )));
        }
      }
    }
    return results;
  }

  @override
  Future<JsonObject> _searchAll(String searchTerm, SearchFilters filters) {
    return Future.delayed(const Duration(seconds: 2), () {
      return {
        "physicians": _generatePhysicians(10),
        "facilities": _generateMedicalFacilities(10),
      };
    });
  }

  @override
  Future<JsonObject> _searchDoctors(String searchTerm, SearchFilters filters) {
    return Future.delayed(const Duration(seconds: 2), () {
      return {"physicians": _generatePhysicians(10), "facilities": []};
    });
  }

  @override
  Future<JsonObject> _searchFacilities(
    String searchTerm,
    SearchFilters filters,
  ) {
    return Future.delayed(const Duration(seconds: 2), () {
      return {"facilities": _generateMedicalFacilities(10), "physicians": []};
    });
  }

  List<Map<String, dynamic>> _generateMedicalFacilities(int count) {
    final random = Random();
    final names = [
      'مستشفى العروبة',
      'مجمع الشفاء الطبي',
      'مركز البركة الصحي',
      'عيادة الأمل',
      'مستشفى الحياة',
      'مركز الدواء',
      'عيادة الأسرة',
      'مجمع النور الطبي'
    ];
    final cities = [
      'دمشق',
      'حلب',
      'حمص',
      'ادلب',
      'الرقة',
      'دير الزور',
      'الحسكة'
    ];
    final addresses = [
      'شارع المستقبل',
      'حي النور',
      'شارع الحمراء',
      'شارع بغداد',
      'حي الزهور'
    ];

    return List.generate(count, (index) {
      return {
        'id': '${index + 1}',
        'name': names[random.nextInt(names.length)],
        'location':
            '${cities[random.nextInt(cities.length)]}, ${addresses[random.nextInt(addresses.length)]}',
        'emergencyPhoneNumber': '0${random.nextInt(999999999)}',
        'phoneNumber': '0${random.nextInt(999999999)}',
        'mobilePhoneNumber': '0${random.nextInt(999999999)}',
        'rating': random.nextDouble() * 5,
        'description': faker.lorem.sentences(3).join(", "),
      };
    });
  }

  List<Map<String, dynamic>> _generatePhysicians(int count) {
    final random = Random();
    final names = [
      'علي',
      'محمد',
      'فهد',
      'سالم',
      'عبدالله',
      'أحمد',
      'خالد',
      'سعيد',
      'يوسف',
      'زايد'
    ];
    final cities = [
      'دمشق',
      'حلب',
      'حمص',
      'طرطوس',
      'اللاذقية',
      'ريف دمشق',
    ];
    final languages = [
      ['العربية', 'الإنجليزية'],
      ['العربية', 'الفرنسية'],
      ['العربية', 'الألمانية'],
      ['العربية', 'الإسبانية'],
      ['العربية', 'التركية']
    ];
    final specialties = [
      'جراحة عامة',
      'أمراض قلب',
      'طب أطفال',
      'طب الأسرة',
      'أمراض جلدية'
    ];

    final qualifications = [
      'بكالوريوس الطب والجراحة',
      'ماجستير في الجراحة العامة',
      'دكتوراه في أمراض القلب',
      'زمالة في طب الأطفال',
      'دبلوم في الطب الأسري'
    ];

    return List.generate(count, (index) {
      return {
        'id': '${index + 1}',
        'name': names[random.nextInt(names.length)],
        'location': cities[random.nextInt(cities.length)],
        'dateOfBirth': DateTime(random.nextInt(100) + 1923,
                random.nextInt(12) + 1, random.nextInt(28) + 1)
            .toString(),
        'isMale': random.nextBool(),
        'rating': random.nextDouble() * 5,
        'phoneNumber': '0${random.nextInt(999999999)}',
        'mobilePhoneNumber': '0${random.nextInt(999999999)}',
        'biography':
            'طبيب متخصص في ${specialties[random.nextInt(specialties.length)]}، حاصل على ${qualifications[random.nextInt(qualifications.length)]}',
        'languages': languages[random.nextInt(languages.length)],
        'specialties': [specialties[random.nextInt(specialties.length)]],
      };
    });
  }
}
