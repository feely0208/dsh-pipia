// 人脸核身：已做影响评估，见 docs/pipia-2026-face.md
async function verify(userId, imageBase64) {
  const faceId = await extractFace(imageBase64);
  await upload(userId, { faceId });   // 仅传哈希，不传原图与用户资料
}
