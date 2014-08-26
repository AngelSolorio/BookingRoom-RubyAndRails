module ErrorCode
  #POSSIBLE ERROR CODES FOR:
  #SESSIONS (100-200)
  INVALID_TOKEN = 101 #Used when the token that belongs to the user is incorrect, or has expired
  INVALID_CREDENTIALS = 102 #Used when the user has an invalid combination of credentials when loggging in
  UNAUTHORIZED_USER = 103 #Used when the user access unauthorized content
  #USERS (200-300)
  USER_VALIDATION = 201 #Used when there are errors in the user model validation
  #BOOKINGS (300-400)
  BOOKING_VALIDATION = 301 #Used when there are errors in the booking model validation
  #SUGGESTIONS (400-500)
  SUGGESTION_VALIDATION = 401 #Used when there are errors in the suggestion model validation
  #MEETING_ROOMS (500-600)
  MEETING_ROOM_VALIDATION = 501 #User when there are errors in the meeting room model validation
end