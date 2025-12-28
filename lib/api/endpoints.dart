class ApiRoutes {
  // Auth Routes
  static const authRoutes = (
    signup: '/register',
    login: '/login',
    logout: '/logout',
    requestVerificationCode: '/request_otp',
    verifyAccount: '/verify_otp',
  );

  // User Routes
  static const userRoutes = (index: '', currentUser: '/me');

  // Medical Entities Routes
  static const conditionsRoute = '/medical-conditions';
  static const departmentsRoute = '/medical-departments';
  static const proceduresRoute = '/medical-procedures';
  static const specialtiesRoute = '/medical-specialties';

  // Physician Routes
  static const physicianBaseRoute = '/physicians';
  static const physicianAccountRoutes = (
    create: '',
    update: '/me',
    treatConditions: "/me/treat-conditions",
    providedProcedures: "/me/provided-procedures",
    languages: "/me/languages",
    specialties: "/me/specialties",
  );
  static String physicianFeedbackRoutes(String physicianId) =>
      '/$physicianId/received-feedback';
  static ({
    String Function(String physicianId, String reviewId) byId,
    String Function(String physicianId) index,
  })
  get physicianReviewsRoutes => (
    index: (String physicianId) => '/$physicianId/reviews',
    byId: (String physicianId, String reviewId) =>
        '/$physicianId/reviews/$reviewId',
  );
  // Medical Facility Routes
  static const medicalFacilityBaseRoute = '/medical-facilities';
  static String facilityFeedbackRoutes(String facilityId) =>
      '/$facilityId/received-feedback';
  static ({
    String Function(String facilityId, String reviewId) byId,
    String Function(String facilityId) index,
  })
  get facilityReviewsRoutes => (
    index: (String facilityId) => '/$facilityId/reviews',
    byId: (String facilityId, String reviewId) =>
        '/$facilityId/reviews/$reviewId',
  );
  static ({
    String Function(String facilityId, String resourceId) getByIdAndFacilityId,
    String Function(String facilityId) getFacilityItems,
  })
  get facilityPatientVisitorResource => (
    getFacilityItems: (String facilityId) =>
        '/$facilityId/patient-visitor-resources',
    getByIdAndFacilityId: (String facilityId, String resourceId) =>
        '/$facilityId/patient-visitor-resources/$resourceId',
  );
}
