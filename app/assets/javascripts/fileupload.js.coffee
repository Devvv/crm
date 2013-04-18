###
file_slicer = (file) ->
  reader = new FileReader()
  @slice_size = 1024 * 1024
  @slices = Math.ceil(file.size / @slice_size)
  @current_slice = 0;
  @get_next = () =>
    start = @current_slice * @slice_size
    end = Math.min((@current_slice + 1) * @slice_size, file.size)
    ++@current_slice
    t = file.slice start, end
    console.log t
  this

$('input.file_name_input').live "change", ->

  file = this.files[0]
  slicer = file_slicer(file)

  WS.trigger("ext.upload", slicer.get_next()) while slicer.current_slice < slicer.slices


