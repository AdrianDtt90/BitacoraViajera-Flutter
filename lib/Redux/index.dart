import 'package:redux/redux.dart';

//Initial State
Map<String,dynamic> initialState = {
  "userLogin": null
};

//Store
final store = new Store<Map<String,dynamic>>(counterReducer, initialState: initialState);
  

// Reducer
Map<String,dynamic> counterReducer(Map<String,dynamic> state, dynamic action) {
  
  if (action is LoggedUserAction) {
    state['userLogin'] = action.user;
    return state;
  }

  return state;
}

//Classes Actions
class LoggedUserAction {
  final Map<String,dynamic> user;

  LoggedUserAction(this.user);
}