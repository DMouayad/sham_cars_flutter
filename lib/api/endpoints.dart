class ApiRoutes {
  // Auth Routes
  static const authRoutes = (
    signup: '/register',
    login: '/login',
    logout: '/logout',
    requestVerificationCode: '/request_otp',
    verifyAccount: '/verify_otp',
    forgotPassword: '/forget-password',
    resetPassword: '/user/change_password',
  );

  // User Routes
  static const userRoutes = (index: '', currentUser: '/user/profile');
}
