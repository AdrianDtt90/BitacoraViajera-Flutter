import 'package:redux/redux.dart';

//Initial State
Map<String,dynamic> initialState = {
  "userLogin": null
};

//Store
final store = new Store<Map<String,dynamic>>(counterReducer, initialState: initialState);
  

// Reducer
Map<String,dynamic> counterReducer(Map<String,dynamic> state, dynamic action) {
  
  if (action is LogInAction) {
    state['userLogin'] = action.user;
    return state;
  }

  if (action is LogOutAction) {
    state['userLogin'] = null;
    return state;
  }

  return state;
}

//Classes Actions
class LogInAction {
  final Map<String,dynamic> user;

  LogInAction(this.user);
}

class LogOutAction {
  LogOutAction();
}