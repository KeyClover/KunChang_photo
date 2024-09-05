class RestDataSouce {
  String baseAPI = 'http://203.150.53.11:9001/CSCPlusAPIdev/swagger/';

  String GetFile({required int id}) {
    String url = '${baseAPI}FileUpload/GetFile?id=$id';
    return url;
  }

  String GetListFile({required int docId}){
    String url = '${baseAPI}FileUpload/GetListFile?docId=$docId';
    return url;
  }

  String PostMultiFiles({required int docId, required String imageType, required int createBy}){
    String url = '${baseAPI}FileUpload/PostMultiFiles?docId=$docId&imageType=$imageType&createBy=$createBy';
    return url;
  }

  String DeleteFile({required int id}){
    String url = '${baseAPI}FileUpload/DeleteFile?id=$id';
    return url;
  }

  String DeleteFilesByDocId({required docId}){
    String url = '${baseAPI}FileUpload/DeleteFilesByDocId?docId=$docId';
    return url;
  }

}
