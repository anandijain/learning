import bpy

# def add_transform(seq):
#    cur_frame = bpy.context.scene.frame_current
#    c = 7
#    bpy.ops.sequencer.effect_strip_add(type="TRANSFORM", channel=(c+1), frame_start=cur_frame)


def add_movie(fn="/home/sippycups/Videos/short_clips/projector.mp4"):
    cur_frame = bpy.context.scene.frame_current
    channel = 7
    bpy.ops.sequencer.movie_strip_add(
        filepath=fn, frame_start=cur_frame, channel=channel
    )


if __name__ == "__main__":
    add_movie()
