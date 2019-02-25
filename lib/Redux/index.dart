import 'package:redux/redux.dart';

//Initial State
Map<String,dynamic> initialState = {
  "userLogin": false
};

//Store
final store = new Store<Map<String,dynamic>>(counterReducer, initialState: initialState);
  
//Actions
enum Actions { 
  UserLogin
 }

// Reducer
Map<String,dynamic> counterReducer(Map<String,dynamic> state, dynamic action) {
  if (action == Actions.UserLogin) {
    state['userLogin'] = true;
    return state;
  }

  return state;
}