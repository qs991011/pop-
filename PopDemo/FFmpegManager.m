//
//  FFmpegManager.m
//  PopDemo
//
//  Created by qiansheng on 2017/7/6.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "FFmpegManager.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>

@implementation FFmpegManager

- (void)TransferDecode {
    AVFormatContext *pFormatCtx;
    int              i,videoindex;
    AVCodecContext  *pCodecCtx;
    AVCodec         *pCodec;
    AVFrame *pFrame,*pFrameYUV;
    uint8_t *out_buffer;
    AVPacket *packet;
    int y_size;
    int ret,got_picture;
    struct SwsContext *img_convert_ctx;
    FILE *fp_yuv;
    int frame_cnt;
    clock_t time_start,time_finish;
    double time_duration = 0.0;
    
    char input_str_full[500]={0};
    char output_str_full[500]={0};
    char info[1000]={0};
    
    NSString *input_str = [NSString stringWithFormat:@"resource.bundle/%@",self.inputurl];
    NSString *output_str = [NSString stringWithFormat:@"resource.bundle/%@",self.outputurl];
    
    NSString *input_nsstr = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:input_str];
    NSString *output_nsstr = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:output_str];
    
    sprintf(input_str_full, "%s",[input_nsstr UTF8String]);
    sprintf(output_str_full, "%s",[output_nsstr UTF8String]);
    
    printf("Input path:%s\n",input_str_full);
    printf("Output_path:%s\n",output_str_full);
    
    //注册所以组件
    av_register_all();
    avformat_network_init();
    pFormatCtx = avformat_alloc_context();
    int errcode;
    errcode = avformat_open_input(&pFormatCtx, input_str_full, NULL, NULL);
    if (errcode != 0) {
        printf("Couldn't open input stream.\n");
        return;
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL)<0) {
        printf("Coundn't find stream information.\n");
        return;
    }
    
    videoindex = -1;
    for (i = 0 ;i<pFormatCtx->nb_streams;i++) {
        if (pFormatCtx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoindex = i;
            break;
        }
    }
    if (videoindex == -1) {
        printf("Count't find a video stream.\n");
        return;
    }
    
    pCodecCtx = pFormatCtx->streams[videoindex]->codec;
    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (pCodec == NULL) {
        printf("Coundn't find Codec.\n");
        return;
    }
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL)<0) {
        printf("Coundn't find codec.\n");
        return;
    }
    
    pFrame = av_frame_alloc();
    pFrameYUV = av_frame_alloc();
    
    out_buffer = (unsigned char *)av_malloc(av_image_get_buffer_size(AV_PIX_FMT_YUV420P,pCodecCtx->width,pCodecCtx->height,1));
    
    av_image_fill_arrays(pFrameYUV->data,pFrameYUV->linesize,out_buffer,AV_PIX_FMT_YUV420P,pCodecCtx->width,pCodecCtx->height,1);
    
    packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    
    img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_YUV420P, SWS_BICUBIC, NULL, NULL, NULL);
    
    sprintf(info,   "[Input   ]%s\n",[input_str UTF8String]);
    sprintf(info, "%s[Output  ]%s\n",info,[output_str UTF8String]);
    sprintf(info, "%s[Format  ]%s\n",info,pFormatCtx->iformat->name);
    sprintf(info, "%s[Codec   ]%s\n",info,pCodecCtx->codec->name);
    sprintf(info, "%s[Resolution]%dx%d\n",info,pCodecCtx->width,pCodecCtx->height);
    
    fp_yuv=fopen(output_str_full, "wb+");
    if (fp_yuv==NULL) {
        printf("Canot open output file.\n");
        return;
    }
    
    frame_cnt = 0;
    time_start = clock();
    while (av_read_frame(pFormatCtx, packet)>=0) {
        if (packet->stream_index == videoindex) {
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if (ret < 0) {
                printf("Decode Error.\n");
                return;
            }
            if (got_picture) {
                sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameYUV->data, pFrameYUV->linesize);
                
                y_size = pCodecCtx->width*pCodecCtx->height;
                fwrite(pFrameYUV->data[0], 1, y_size, fp_yuv);//y
                fwrite(pFrameYUV->data[1], 1, y_size/4, fp_yuv);//U
                fwrite(pFrameYUV->data[2], 1, y_size/4, fp_yuv);//v
                char pictype_str[10]={0};
                switch (pFrame->pict_type) {
                    case AV_PICTURE_TYPE_I:
                        sprintf(pictype_str, "I");
                        break;
                    case AV_PICTURE_TYPE_P:
                        sprintf(pictype_str, "P");
                        break;
                    case AV_PICTURE_TYPE_B:
                        sprintf(pictype_str, "B");
                        break;
                    default:
                        sprintf(pictype_str, "Other");
                        break;
                }
                printf("Frame Index:%5d. Type:%s\n",frame_cnt,pictype_str);
                frame_cnt++;
            }
        }
        //av_packet_unref(packet);
        av_free_packet(packet);
    }
    
    while (1) {
        //ret = avcodec_send_frame(pCodecCtx, pFrame);
        //ret = avcodec_receive_frame(pCodecCtx, pFrame);
        ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
        if (ret < 0)
            break;
        if (!got_picture)
            break;
        sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameYUV->data, pFrameYUV->linesize);
        int y_size=pCodecCtx->width*pCodecCtx->height;
        fwrite(pFrameYUV->data[0], 1, y_size, fp_yuv);
        fwrite(pFrameYUV->data[1], 1, y_size/4, fp_yuv);
        fwrite(pFrameYUV->data[2], 1, y_size/4, fp_yuv);
        char pictype_str[10]={0};
        switch (pFrame->pict_type) {
            case AV_PICTURE_TYPE_I: sprintf(pictype_str, "I");break;
            case AV_PICTURE_TYPE_P: sprintf(pictype_str, "P");break;
            case AV_PICTURE_TYPE_B: sprintf(pictype_str, "B");break;
                
            default:sprintf(pictype_str, "Other");break;
        }
        printf("Frame Index : %5d. Type:%s\n",frame_cnt,pictype_str);
        frame_cnt++;
    }
    time_finish = clock();
    time_duration = (double)(time_finish - time_start);
    
    sprintf(info, "%s[Time    ]%fus\n",info,time_duration);
    sprintf(info, "%s[Count   ]%d\n",info,frame_cnt);
    
    sws_freeContext(img_convert_ctx);
    fclose(fp_yuv);
    
    av_frame_free(&pFrameYUV);
    av_frame_free(&pFrame);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
    
    NSString *info_ns = [NSString stringWithFormat:@"%s",info];
    NSLog(@"%@",info_ns);
    
    
}



@end
