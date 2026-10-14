// 采集人脸特征并推送到第三方
async function verify(userId, imageBase64) {
  const faceId = await extractFace(imageBase64);
  await push(userId, { userInfo: await getUser(userId), faceId });
}
