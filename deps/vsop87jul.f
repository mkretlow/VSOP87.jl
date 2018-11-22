!     ==============================================================================================================================
!     Wrapper subroutine: handles file open/close and LU and calls vsop87()n subroutine
!
!     TODO: keep Files open between subsequent calls
!     ==============================================================================================================================
      subroutine vsop87jul(ddir,ic,tjd,ivers,ibody,prec,rar,ierr)

      implicit none

      integer lu0,lu,ivers,ibody,ierr,ic
      real*8  tjd,prec,rar(6)

      logical fexist

      character*1   a(0:5)
      character*4   ext(0:9)
      character*6   prefix
      character*7   vers
      character*256 ddir,fname

      data a/' ','A','B','C','D','E'/
      data ext/'.sun','.mer','.ven','.ear','.mar','.jup',
     .         '.sat','.ura','.nep','.emb'/

      data prefix /'VSOP87'/

      fexist = .false.
      ierr = 0
      lu0 = 0

      lu = ivers*10 + 10 + ibody

      if (lu0.ne.0 .and. lu0.ne.lu) close(lu0)

      if (ivers.eq.0)
     .fname = trim(ddir(1:ic))//'/'//prefix//ext(ibody)

      if (ivers.ne.0)
     .fname = trim(ddir(1:ic))//'/'//prefix//a(ivers)//ext(ibody)

      inquire (file = fname, exist = fexist)

      if (fexist) then
         if (lu.ne.lu0) then
            open (lu,file = fname, status = 'old', iostat = ierr)
            if (ierr.ne.0) return
            lu0 = lu
         endif
      else
         close(lu)
         ierr = -1
         return
      endif

      call VSOP87(tjd,ivers,ibody,prec,lu,rar,ierr)

      close(lu)

      end
