import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:focial/api/urls.dart';
import 'package:focial/services/auth.dart';
import 'package:get_it/get_it.dart';

part 'api.chopper.dart';

final auth = GetIt.I<AuthService>();

@ChopperApi()
abstract class FocialAPI extends ChopperService {
  /// auth apis
  @Post(path: Urls.REGISTER)
  Future<Response<dynamic>> register(
      {@Field() String name, @Field() String email, @Field() String password});

  @Post(path: Urls.LOGIN)
  Future<Response<dynamic>> login(
      {@Field() String email, @Field() String password});

  @Get(path: Urls.GET_USER)
  Future<Response<dynamic>> getUser();

  @Post(path: Urls.UPLOAD_PROFILE_PICTURE)
  @multipart
  Future<Response> uploadProfilePicture(@PartFile("file") String file);

  @Post(path: Urls.UPLOAD_COVER_PICTURE)
  @multipart
  Future<Response> uploadCoverPicture(@PartFile("file") String file);

  static FocialAPI create() {
    final client = ChopperClient(
        baseUrl: Urls.BASE_URL,
        services: [
          _$FocialAPI(),
        ],
        interceptors: [HttpLoggingInterceptor(), HeadersInterceptor()],
        converter: JsonConverter());
    return _$FocialAPI(client);
  }
}

class HeadersInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    var headers = {
      "Content-Type": "application/json",
    };

    // print(auth.authData.accessToken);
    print(request.body);
    headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer ${auth.authData.accessToken}"
    });

    return request.copyWith(headers: headers);
  }
}
