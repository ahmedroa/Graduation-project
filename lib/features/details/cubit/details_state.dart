part of 'details_cubit.dart';

class DetailsState {
  final bool isLiked;
  final bool isLikeLoading;
  final int likesCount;
  final String? error;
  
  // Comments states
  final List<Comment> lastThreeComments;
  final List<Comment> allComments;
  final bool isCommentsLoading;
  final bool isAddingComment;

  DetailsState({
    this.isLiked = false,
    this.isLikeLoading = false,
    this.likesCount = 0,
    this.error,
    this.lastThreeComments = const [],
    this.allComments = const [],
    this.isCommentsLoading = false,
    this.isAddingComment = false,
  });

  DetailsState copyWith({
    bool? isLiked,
    bool? isLikeLoading,
    int? likesCount,
    String? error,
    List<Comment>? lastThreeComments,
    List<Comment>? allComments,
    bool? isCommentsLoading,
    bool? isAddingComment,
  }) {
    return DetailsState(
      isLiked: isLiked ?? this.isLiked,
      isLikeLoading: isLikeLoading ?? this.isLikeLoading,
      likesCount: likesCount ?? this.likesCount,
      error: error,
      lastThreeComments: lastThreeComments ?? this.lastThreeComments,
      allComments: allComments ?? this.allComments,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      isAddingComment: isAddingComment ?? this.isAddingComment,
    );
  }
}

// نموذج التعليق
class Comment {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String comment;
  final DateTime? timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.comment,
    this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'مستخدم',
      userProfileImage: map['userProfileImage'],
      comment: map['comment'] ?? '',
      timestamp: map['timestamp']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}

// class DetailsState {
//   final bool isLiked;
//   final bool isLikeLoading;
//   final int likesCount;
//   final String? error;

//   DetailsState({
//     this.isLiked = false,
//     this.isLikeLoading = false,
//     this.likesCount = 0,
//     this.error,
//   });

//   DetailsState copyWith({
//     bool? isLiked,
//     bool? isLikeLoading,
//     int? likesCount,
//     String? error,
//   }) {
//     return DetailsState(
//       isLiked: isLiked ?? this.isLiked,
//       isLikeLoading: isLikeLoading ?? this.isLikeLoading,
//       likesCount: likesCount ?? this.likesCount,
//       error: error ?? this.error,
//     );
//   }
// }