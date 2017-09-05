//
//  FFmpegStreamer.m
//  PopDemo
//
//  Created by qiansheng on 2017/7/10.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "FFmpegStreamer.h"
#include <libavformat/avformat.h>
#include <libavutil/mathematics.h>
#include <libavutil/time.h>
@implementation FFmpegStreamer

- (void)pushStream{
    char input_str_full[500] = {0};
    char out_str_full[500] = {0};
    
    NSString *input_str = [NSString stringWithFormat:@"resource.bundle/%@",self.inputurl];
    NSString *input_nsstr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:input_str];
    
    sprintf(input_str_full, "%s",[input_nsstr UTF8String]);
    sprintf(out_str_full, "%s",[self.outputurl UTF8String]);
    
    printf("Input Path:%s\n",input_str_full);
    printf("Output path:%s\n",out_str_full);
    
    AVOutputFormat *ofmt = NULL;
    
    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
    
    AVPacket pkt;
    char in_filename[500] = {0};
    char out_filename[500] = {0};
    int ret, i ;
    int videoindex = -1;
    int frame_index = 0;
    int64_t start_time=0;
    
    
    strcpy(in_filename, input_str_full);
    strcpy(out_filename, out_str_full);
    
    av_register_all();
    avformat_network_init();
    
    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) < 0) {
        printf("Cound not open input file.");
        goto end;
    }
    
    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0 ){
        printf("Failed to retrieve input stream information");
        goto end;
    }
    
    for ( i = 0; i < ifmt_ctx->nb_streams; i++) {
        if (ifmt_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoindex = i;
            break;
        }
    }
        
    
    
    av_dump_format(ifmt_ctx, 0, in_filename, 0);
    //ofmt_ctx = avformat_alloc_context();
    avformat_alloc_output_context2(&ofmt_ctx, NULL, "flv", out_filename);//RTMP
    
    // avformat_alloc_output_context2(&ofmt_ctx, NULL, "mpegts", out_filename);//UDP
        
    if (!ofmt_ctx) {
        printf("Cound not create output context\n");
        ret  = AVERROR_UNKNOWN;
        goto end;
        
    }
    
    ofmt = ofmt_ctx->oformat;
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVCodec *codec = avcodec_find_decoder(in_stream->codecpar->codec_id);
        AVStream *out_stram = avformat_new_stream(ofmt_ctx, codec);
        if (!out_stram) {
            printf("Failed allocating output stream\n");
            ret = AVERROR_UNKNOWN;
            goto end;
        }
         AVCodecContext *in_ctx = avcodec_alloc_context3(codec);
        //向一个AVCodecContent拷贝一个AVCodecParameters
        ret = avcodec_parameters_to_context(in_ctx, in_stream->codecpar);
        ret = avcodec_parameters_from_context(out_stram->codecpar, in_ctx);
        if (ret < 0) {
            printf("Failed to copy context  input to output  codec context\n");
            goto end;
        }
        if (ret < 0) {
            printf("Failed to copy context  input to output  codec context\n");
            goto end;
        }
         out_stram->codecpar->codec_tag = 0;
        
        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER) {
            
            in_ctx->flags |= CODEC_FLAG_GLOBAL_HEADER;
        }
        //从一个AVCodecContent中拷贝出AVCodecParameters
        
        
    }
    av_dump_format(ofmt_ctx, 0, out_filename, 1);
    
    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            printf("Cound not open output URL '%s'",out_filename);
            goto end;
        }
    }
    //avformat_alloc_context()
    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        printf("Error occurred when opening output URL\n");
        goto end;
    }
    
    start_time = av_gettime();
    while (1) {
        AVStream *in_stream, *out_stream;
        ret = av_read_frame(ifmt_ctx, &pkt);
        if (ret < 0)
            break;
        if (pkt.pts == AV_NOPTS_VALUE) {
            //write PTS
            AVRational time_base1=ifmt_ctx->streams[videoindex]->time_base;
            // Duration between 2 frames
            int64_t calc_duration = (double)AV_TIME_BASE/av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
            // Parameters
            pkt.pts = (double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
            pkt.dts =pkt.pts;
            pkt.duration = (double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
        }
        if (pkt.stream_index == videoindex) {
            AVRational time_base = ifmt_ctx->streams[videoindex]->time_base;
            AVRational time_base_q = {1,AV_TIME_BASE};
            int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
            int64_t now_time = av_gettime() - start_time;
            if (pts_time > now_time) {
                av_usleep(pts_time - now_time);
            }
        }
        in_stream = ifmt_ctx->streams[pkt.stream_index];
        out_stream = ofmt_ctx->streams[pkt.stream_index];
        
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_INF | AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        
        pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
        pkt.pos = -1;
        if (pkt.stream_index == videoindex) {
            printf("Send %8d video frames to output URL\n",frame_index);
            frame_index++;
        }
        //ret = av_write_frame(ofmt_ctx, &pkt);
        ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
        
        if (ret < 0) {
            printf("Error muxing packet\n");
            break;
        }
        av_packet_unref(&pkt);
    }
    //写文件尾 write file trailer
    av_write_trailer(ofmt_ctx);
end:
    avformat_close_input(&ifmt_ctx);
    if (ofmt_ctx && (ofmt->flags & AVFMT_NOFILE)) {
        avio_close(ofmt_ctx->pb);
    }
    avformat_free_context(ofmt_ctx);
    if (ret < 0 && ret != AVERROR_EOF) {
        printf("Error occurred.\n");
        return;
    }
    return;

}
@end
