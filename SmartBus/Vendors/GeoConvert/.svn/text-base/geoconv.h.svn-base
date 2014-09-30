/*
 * gconv.h
 *
 *  Created on: May 14, 2013
 *      Author: casa
 */

#ifndef GEOCONV_H_
#define GEOCONV_H_

#ifdef __cplusplus
extern "C" {
#endif

/*
 * name: geodist
 * desc: 计算两个坐标间的距离
 * in:   lat0 坐标一的纬度
 *       lng0 坐标一的经度
 *       lat1 坐标二的纬度
 *       lng1 坐标二的经度
 * ret:  距离（单位米）
 */
double geodist(double lat0, double lng0, double lat1, double lng1);

/*
 * name: real2google
 * desc: 将真实坐标转为谷歌坐标（加偏）
 * in:   inlat 真实的纬度
 *       inlng 真实的经度
 * out:  outlat 谷歌坐标的纬度
 *       outlng 谷歌坐标的经度
 */
void real2google(double inlat, double inlng, double *outlat, double *outlng);

/*
 * name: google2real
 * desc: 将谷歌坐标转为真实坐标（纠偏）
 * in:   inlat 谷歌坐标的纬度
 *       inlng 谷歌坐标的经度
 * out:  outlat 真实的纬度
 *       outlng 真实的经度
 */
void google2real(double inlat, double inlng, double *outlat, double *outlng);

/*
 * name: real2baidu
 * desc: 将真实坐标转为百度坐标（加偏）
 * in:   inlat 真实的纬度
 *       inlng 真实的经度
 * out:  outlat 百度坐标的纬度
 *       outlng 百度坐标的经度
 */
void real2baidu(double inlat, double inlng, double *outlat, double *outlng);

/*
 * name: baidu2real
 * desc: 将百度坐标转为真实坐标（纠偏）
 * in:   inlat 百度坐标的纬度
 *       inlng 百度坐标的经度
 * out:  outlat 真实的纬度
 *       outlng 真实的经度
 */
void baidu2real(double inlat, double inlng, double *outlat, double *outlng);

/*
 * name: baidu2google
 * desc: 将百度坐标转为谷歌坐标
 * in:   inlat 百度坐标的纬度
 *       inlng 百度坐标的经度
 * out:  outlat 谷歌坐标的纬度
 *       outlng 谷歌坐标的经度
 */
void baidu2google(double inlat, double inlng, double *outlat, double *outlng);

/*
 * name: google2baidu
 * desc: 将谷歌坐标转为百度坐标
 * in:   inlat 谷歌坐标的纬度 
 *       inlng 谷歌坐标的经度 
 * out:  outlat 百度坐标的纬度
 *       outlng 百度坐标的经度
 */
void google2baidu(double inlat, double inlng, double *outlat, double *outlng);

#ifdef __cplusplus
}
#endif

#endif /* GEOCONV_H_ */
