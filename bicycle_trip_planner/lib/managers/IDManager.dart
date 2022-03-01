class IDManager{
  static int _currentUID = 0; 

  static final IDManager _idManager = IDManager._internal();

  factory IDManager() {
    return _idManager;
  }

  IDManager._internal();

  int generateUID(){return ++_currentUID;}
}

