const _cdnBaseUrl = 'https://cdn.toyvillage.kr';

String documentFileUrl(String fileKey) =>
    '$_cdnBaseUrl/${Uri.encodeComponent(fileKey)}';
