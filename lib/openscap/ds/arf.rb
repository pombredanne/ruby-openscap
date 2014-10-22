#
# Copyright (c) 2014 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap/source'
require 'openscap/libc'

module OpenSCAP
  module DS
    class Arf
      def initialize(input_filename)
        @source = OpenSCAP::Source.new(input_filename)
        @session = OpenSCAP.ds_rds_session_new_from_source @source.raw
        if @session.null?
          OpenSCAP.raise!
        end
      end

      def destroy
        OpenSCAP.ds_rds_session_free(@session)
        @session = nil
        @source.destroy()
      end

      def html
        html_p = OpenSCAP.ds_rds_session_get_html_report @session
        OpenSCAP.raise! if OpenSCAP.error?
        return nil if html_p.null?
        html = html_p.read_string()
        OpenSCAP::LibC.free html_p
        return html
      end
    end
  end

  attach_function :ds_rds_session_new_from_source, [:pointer], :pointer
  attach_function :ds_rds_session_free, [:pointer], :void
  attach_function :ds_rds_session_get_html_report, [:pointer], :pointer
end