module Instructor::AttendanceCheckinsHelper
  def qr_code_for_checkin(course_session)
    require 'rqrcode'

    url = short_attendance_checkin_url(course_session)
    # url = "http://192.168.1.2:3000/ac/#{course_session.id}"
    qrcode = RQRCode::QRCode.new(url)

    svg = qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )

    raw(svg)
  end
end


