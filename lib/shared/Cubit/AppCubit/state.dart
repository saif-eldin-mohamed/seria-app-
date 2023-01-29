abstract class socialStates {}

class socialInitialState extends socialStates {}

class socialGetUserLoadingState extends socialStates {}

class socialGetUserSuccessState extends socialStates {}

class socialGetUserErorrState extends socialStates {
  final String? Erorr;

  socialGetUserErorrState(this.Erorr);
}

class socialGetAllUsersLoadingState extends socialStates {}

class socialGetAllUsersSuccessState extends socialStates {}

class socialGetAllUsersErorrState extends socialStates {
  final String? Erorr;

  socialGetAllUsersErorrState(this.Erorr);
}

class socialChangedropdownState extends socialStates {}

class socialChangebuttomNavState extends socialStates {}

class socialChangeDateState extends socialStates {}

class socialProfileImagePickedSuccessState extends socialStates {}

class socialProfileImagePickedErorrState extends socialStates {}

class socialProfileCoverPickedSuccessState extends socialStates {}

class socialProfileCoverPickedErorrState extends socialStates {}

class socialUploadProfileImageLoadingState extends socialStates {}

class socialUploadProfileImageSuccessState extends socialStates {}

class socialUploadProfileImageErorrState extends socialStates {}

class socialUploadProfileCoverLoadingState extends socialStates {}

class socialUploadProfileCoverSuccessState extends socialStates {}

class socialUpdateDataLoadingState extends socialStates {}

class socialUpdateDataSuccessState extends socialStates {}

class socialUploadProfileCoverErorrState extends socialStates {}

class socialImagePostPickedSuccessState extends socialStates {}

class socialImagePostPickedErorrState extends socialStates {}

class socialCreatePostLoadingState extends socialStates {}

class socialCreatePostSuccessState extends socialStates {}

class socialCreatePostErorrState extends socialStates {}

class socialDeletePostLoadingState extends socialStates {}

class socialDeletePostSuccessState extends socialStates {}

class socialDeletePostErorrState extends socialStates {}

class socialUPdatePostLoadingState extends socialStates {}

class socialUPdatePostSuccessState extends socialStates {}

class socialUPdatePostErorrState extends socialStates {}

class socialDeletePostImageState extends socialStates {}

class socialGetPostsLoadingState extends socialStates {}

class socialGetPostsSuccessState extends socialStates {}

class socialGetPublicPostsLoadingState extends socialStates {}

class socialGetPublicPostsSuccessState extends socialStates {}

class socialLikePostSuccessState extends socialStates {}

class socialLikePostErorrState extends socialStates {
  final String? Erorr;

  socialLikePostErorrState(this.Erorr);
}

class socialCommentPostSuccessState extends socialStates {}

class socialCommentPostErorrState extends socialStates {
  final String? Erorr;

  socialCommentPostErorrState(this.Erorr);
}

class socialGetCommentPostLoadingState extends socialStates {}

class socialGetCommentPostSuccessState extends socialStates {}

class socialGetLikesPrivatePostSuccessState extends socialStates {}

class socialGetLikesPostSuccessState extends socialStates {}

class socialGetCommentPostErorrState extends socialStates {
  final String? Erorr;

  socialGetCommentPostErorrState(this.Erorr);
}

class socialGetLikeCommentPostLoadingState extends socialStates {}

class socialGetLikeCommentPostSuccessState extends socialStates {}

class socialGetLikeCommentPostErorrState extends socialStates {
  final String? Erorr;

  socialGetLikeCommentPostErorrState(this.Erorr);
}

class socialSendMessgeSuccessState extends socialStates {}

class socialSendMessgeErorrState extends socialStates {}

class socialGetMessgeSuccessState extends socialStates {}

class socialUploadImageMessageLoadingState extends socialStates {}

class socialUploadImageMessageSuccessState extends socialStates {}

class socialUploadImageMessageErorrState extends socialStates {}

class seachuser extends socialStates {}
