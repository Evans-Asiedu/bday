import 'package:fluro/fluro.dart';
import 'package:bdayapp/src/config/route_handler.dart';


class Routes {
  static String root = '/';
  static String addNewPerson = "/addnewperson";

  static void configureRoutes(FluroRouter router){
    router.notFoundHandler = Handler(
        handlerFunc: (context, params){
          return null;
        }
    );

    router.define(root, handler: rootHandler);
    router.define(addNewPerson, handler: addNewPersonHandler);
  }
}