!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! module_hydro_utils.f90 --- 
!!!!
!! subroutine make_boundary(idim)
!! subroutine constoprim(d2max)
!! subroutine eos(q,e,c,d2max)
!! subroutine trace(dtdx,d2max)
!! subroutine slope(d2max)
!! subroutine riemann(d2max)
!! subroutine cmpflx(d2max)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

module hydro_utils

contains

subroutine make_boundary(idim)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  implicit none

  ! Dummy arguments
  integer(kind=prec_int), intent(in) :: idim
  ! Local variables
  integer(kind=prec_int) :: ivar,i,i0,j,j0
  real(kind=prec_real)   :: sign
!!$ integer(kind=prec_int) :: ijet
!!$ real(kind=prec_real) :: djet,ujet,pjet

  if(idim==1)then
     
     ! Left boundary
     do ivar=1,nvar
        do i=1,2           
           sign=1.0_prec_real
           if(boundary_left==1)then
              i0=5-i
              if(ivar==IU)sign=-1.0_prec_real
           else if(boundary_left==2)then
              i0=3
           else
              i0=nx+i
           end if
           do j=jmin+2,jmax-2
              uold(i,j,ivar)=uold(i0,j,ivar)*sign
           end do
        end do
     end do

     ! Right boundary
     do ivar=1,nvar
        do i=nx+3,nx+4
           sign=1.0_prec_real
           if(boundary_right==1)then
              i0=2*nx+5-i
              if(ivar==IU)sign=-1.0_prec_real
           else if(boundary_right==2)then
              i0=nx+2
           else
              i0=i-nx
           end if
           do j=jmin+2,jmax-2
              uold(i,j,ivar)=uold(i0,j,ivar)*sign
           end do
        end do
     end do

  else

     ! Lower boundary
     do ivar=1,nvar
        do j=1,2           
           sign=1.0_prec_real
           if(boundary_down==1)then
              j0=5-j
              if(ivar==IV)sign=-1.0_prec_real
           else if(boundary_down==2)then
              j0=3
           else
              j0=ny+j
           end if
           do i=imin+2,imax-2
              uold(i,j,ivar)=uold(i,j0,ivar)*sign
           end do
        end do
     end do

!!$        djet=1.0
!!$        ujet=300.
!!$        pjet=1.0
!!$        ijet=imax-20 
!!$        do ivar=1,nvar
!!$           do j=1,2           
!!$              do i=ijet,imax-2
!!$                 uold(i,j,1)=djet
!!$                 uold(i,j,2)=0._prec_real
!!$                 uold(i,j,3)=djet*ujet
!!$                 uold(i,j,4)=pjet/(gamma-1)+0.5_prec_real*djet*ujet**2
!!$              end do
!!$           end do
!!$        end do

     ! Upper boundary
     do ivar=1,nvar
        do j=ny+3,ny+4
           sign=1.0_prec_real
           if(boundary_up==1)then
              j0=2*ny+5-j
              if(ivar==IV)sign=-1.0_prec_real
           else if(boundary_up==2)then
              j0=ny+2
           else
              j0=j-ny
           end if
           do i=imin+2,imax-2
              uold(i,j,ivar)=uold(i,j0,ivar)*sign
           end do
        end do
     end do

  end if
end subroutine make_boundary


subroutine constoprim(d2max)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  use hydro_work_space, only : u,q,c
  implicit none

  ! Dummy arguments
  integer(kind=prec_int), intent(in) :: d2max

  ! Local variables
  integer(kind=prec_int) :: i,j,IN,d1min,d1max,d2min
  real(kind=prec_real), dimension(lbound(c,2):d2max) :: eken
  real(kind=prec_real), dimension(:,:), allocatable :: e

  ! Convert to non-conservation form and compute
  ! pressure via equation of state
  d1min = lbound(c,1)
  d1max = ubound(c,1)
  d2min = lbound(c,2)
!  d2max = ubound(c,2)
  allocate(e(d1min:d1max,d2min:d2max))

  do j = d2min, d2max
     do i = d1min, d1max
        q(i,j,ID) = max(u(i,j,ID),smallr)
        q(i,j,IU) = u(i,j,IU)/q(i,j,ID)
        q(i,j,IV) = u(i,j,IV)/q(i,j,ID)
        eken(j) = half*(q(i,j,IU)**2+q(i,j,IV)**2)
        q(i,j,IP) = u(i,j,IP)/q(i,j,ID) - eken(j)     
     end do
  enddo

  if (nvar > 4) then
     do IN = 5, nvar
        do j = d2min, d2max
           do i = d1min, d1max
              q(i,j,IN) = u(i,j,IN)/q(i,j,ID)
           end do
        end do
     end do
  end if

  e(d1min:d1max,d2min:d2max)=q(d1min:d1max,d2min:d2max,IP)

  call eos(q,e,c,d2max)

  deallocate(e)
end subroutine constoprim


subroutine eos(q,e,c,d2max)
  use hydro_const
  use hydro_parameters
  implicit none

  ! Dummy arguments
  real(kind=prec_real), dimension(:,:)  , intent(in)    :: e
  real(kind=prec_real), dimension(:,:)  , intent(inout) :: c
  real(kind=prec_real), dimension(:,:,:), intent(inout) :: q
  integer(kind=prec_int), intent(in) :: d2max

  ! Local variables
  integer(kind=prec_int) :: j,k,d1min,d1max,d2min
  real(kind=prec_real)   :: smallp

  d1min = lbound(c,1)
  d1max = ubound(c,1)
  d2min = lbound(c,2)
!  d2max = ubound(c,2)
 
  smallp = smallc**2/gamma

  do j = d2min, d2max
     do k = d1min, d1max
        q(k,j,IP) = (gamma - one)*q(k,j,ID)*e(k,j)
        q(k,j,IP) = max(q(k,j,IP),q(k,j,ID)*smallp)
        c(k,j)    = sqrt(gamma*q(k,j,IP)/q(k,j,ID))        
     end do
  end do
end subroutine eos


subroutine trace(dtdx,d2max)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  use hydro_work_space, only : q,dq,c,qxm,qxp
  implicit none

  ! Dummy arguments
   real(kind=prec_real), intent(in) :: dtdx
   integer(kind=prec_int), intent(in) :: d2max
  ! Local variables
  integer(kind=prec_int) :: i,j,IN,d1min,d1max,d2min
  real(kind=prec_real)   :: cc,csq,r,u,v,p,a
  real(kind=prec_real)   :: dr,du,dv,dp,da
  real(kind=prec_real)   :: alpham,alphap,alpha0r,alpha0v
  real(kind=prec_real)   :: spminus,spplus,spzero
  real(kind=prec_real)   :: apright,amright,azrright,azv1right,acmpright
  real(kind=prec_real)   :: apleft,amleft,azrleft,azv1left,acmpleft
  real(kind=prec_real)   :: zerol,zeror,project

  d1min = lbound(c,1)
  d1max = ubound(c,1)
  d2min = lbound(c,2)
!  d2max = ubound(c,2)
 
  ! compute slopes
  dq = zero
  if (iorder .ne. 1) then
     call slope(d2max)
  endif

  if(scheme=='muscl')then ! MUSCL-Hancock method
     zerol=-100._prec_real/dtdx
     zeror=+100._prec_real/dtdx
     project=one
  endif
  if(scheme=='plmde')then ! standard PLMDE
     zerol=zero
     zeror=zero
     project=one  
  endif
  if(scheme=='collela')then ! Collela's method
     zerol=zero
     zeror=zero
     project=zero
  endif

  do j = d2min, d2max
     do i = d1min+1, d1max-1
        
        cc = c(i,j)
        csq = cc**2
        r = q(i,j,ID)
        u = q(i,j,IU)
        v = q(i,j,IV)
        p = q(i,j,IP)
        
        dr = dq(i,j,ID)
        du = dq(i,j,IU)
        dv = dq(i,j,IV)
        dp = dq(i,j,IP)
        
        alpham  = half*(dp/(r*cc) - du)*r/cc
        alphap  = half*(dp/(r*cc) + du)*r/cc
        alpha0r = dr - dp/csq
        alpha0v = dv
        
        ! Right state
        spminus = (u-cc)*dtdx+one
        spplus  = (u+cc)*dtdx+one
        spzero  =  u    *dtdx+one
        if((u-cc)>=zeror)spminus=project
        if((u+cc)>=zeror)spplus =project
        if( u    >=zeror)spzero =project
        apright   = -half*spplus *alphap
        amright   = -half*spminus*alpham
        azrright  = -half*spzero *alpha0r
        azv1right = -half*spzero *alpha0v     
        qxp(i,j,ID) = r + (apright + amright + azrright)
        qxp(i,j,IU) = u + (apright - amright           )*cc/r
        qxp(i,j,IV) = v + (azv1right                   )
        qxp(i,j,IP) = p + (apright + amright           )*csq
        
        ! Left state
        spminus = (u-cc)*dtdx-one
        spplus  = (u+cc)*dtdx-one
        spzero  =  u    *dtdx-one
        if((u-cc)<=zerol)spminus=-project
        if((u+cc)<=zerol)spplus =-project
        if( u    <=zerol)spzero =-project
        apleft   = -half*spplus *alphap
        amleft   = -half*spminus*alpham
        azrleft  = -half*spzero *alpha0r
        azv1left = -half*spzero *alpha0v
        qxm(i,j,ID) = r + (apleft + amleft + azrleft)
        qxm(i,j,IU) = u + (apleft - amleft          )*cc/r
        qxm(i,j,IV) = v + (azv1left                 )
        qxm(i,j,IP) = p + (apleft + amleft          )*csq
     end do
  end do

  if (nvar>4)then
     do IN = 5, nvar
        do j = d2min, d2max
           do i = d1min+1, d1max-1
              u  =  q(i,j,IU)
              a  =  q(i,j,IN)
              da = dq(i,j,IN)
              ! Right state
              spzero = u*dtdx+one
              if(u>=zeror)spzero=project
              acmpright = -half*spzero*da
              qxp(i,j,IN) = a + acmpright
              ! Left state
              spzero = u*dtdx-one
              if(u<=zerol)spzero=-project
              acmpleft = -half*spzero*da
              qxm(i,j,IN) = a + acmpleft
           end do
        end do
     end do
  end if
end subroutine trace


subroutine slope(d2max)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  use hydro_work_space, only : q,dq
  implicit none

  ! Dummy argument
  integer(kind=prec_int), intent(in) :: d2max
  ! Local arrays
  integer(kind=prec_int) :: i,j,n,d1min,d1max,d2min
  real(kind=prec_real)   :: dsgn,dlim,dcen,dlft,drgt,slop

  d1min = lbound(q,1)
  d1max = ubound(q,1)
  d2min = lbound(q,2)
!  d2max = ubound(q,2)
 
  do j=d2min,d2max
     do n = 1, nvar
        do i = d1min+1, d1max-1        
           dlft = slope_type*(q(i,j  ,n) - q(i-1,j,n))
           drgt = slope_type*(q(i+1,j,n) - q(i,j  ,n))
           dcen = half*(dlft+drgt)/slope_type
           dsgn = sign(one, dcen)
           slop = min(abs(dlft),abs(drgt))
           dlim = slop
           if((dlft*drgt)<=zero)dlim=zero
           dq(i,j,n) = dsgn*min(dlim,abs(dcen))
        end do
     end do
  end do
end subroutine slope


subroutine riemann(d2max)
  use hydro_const
  use hydro_parameters
  use hydro_work_space, only : qleft,qright,qgdnv, &
                               rl,ul,pl,cl,wl,rr,ur,pr,cr,wr,ro,uo,po,co,wo, &
                               rstar,ustar,pstar,cstar,sgnm,spin,spout, &
                               ushock,frac,scr,delp,pold,ind,ind2
  implicit none

  ! Dummy argument
  integer(kind=prec_int),intent(in) :: d2max
  ! Local variables
  real(kind=prec_real)   :: smallp,gamma6,ql,qr,usr,usl,wwl,wwr,smallpp
  integer(kind=prec_int) :: i,j,k,in,n,iter,n_new,nface,d1min,d1max,d2min

  ! Constants
  smallp = smallc**2/gamma
  smallpp = smallr*smallp
  gamma6 = (gamma+one)/(two*gamma)

  d1min = lbound(qleft,1)
  d1max = ubound(qleft,1)
  d2min = lbound(qleft,2)
!  d2max = ubound(qleft,2)

  ! Pressure, density and velocity
  do j=d2min,d2max
     do i=d1min,d1max
        rl(i,j)=MAX(qleft (i,j,ID),smallr)
        ul(i,j)=    qleft (i,j,IU)
        pl(i,j)=MAX(qleft (i,j,IP),rl(i,j)*smallp)
        rr(i,j)=MAX(qright(i,j,ID),smallr)
        ur(i,j)=    qright(i,j,IU)
        pr(i,j)=MAX(qright(i,j,IP),rr(i,j)*smallp)
     end do
  end do

  ! Lagrangian sound speed
  do  j=d2min,d2max
     do i=d1min,d1max
        cl(i,j) = gamma*pl(i,j)*rl(i,j)
        cr(i,j) = gamma*pr(i,j)*rr(i,j)
     end do
  end do

  ! First guess
  do  j=d2min,d2max
     do i=d1min,d1max
        wl(i,j) = sqrt(cl(i,j))
        wr(i,j) = sqrt(cr(i,j))
        pstar(i,j) = ((wr(i,j)*pl(i,j)+wl(i,j)*pr(i,j))+wl(i,j)*wr(i,j)*(ul(i,j)-ur(i,j)))/(wl(i,j)+wr(i,j))
        pstar(i,j) = MAX(pstar(i,j),0.d0)
        pold(i,j) = pstar(i,j)
     end do
  end do

  do i = d1min, d1max
     ind(i,d2min:d2max)=i
  end do

  ! Newton-Raphson iterations to find pstar at the required accuracy
  do j = d2min, d2max
     n = d1max
     do iter = 1,niter_riemann
        do i=d1min, n
           wwl=sqrt(cl(ind(i,j),j)*(one+gamma6*(pold(i,j)-pl(ind(i,j),j))/pl(ind(i,j),j)))
           wwr=sqrt(cr(ind(i,j),j)*(one+gamma6*(pold(i,j)-pr(ind(i,j),j))/pr(ind(i,j),j)))
           ql=two*wwl**3/(wwl**2+cl(ind(i,j),j))
           qr=two*wwr**3/(wwr**2+cr(ind(i,j),j))
           usl=ul(ind(i,j),j)-(pold(i,j)-pl(ind(i,j),j))/wwl
           usr=ur(ind(i,j),j)+(pold(i,j)-pr(ind(i,j),j))/wwr
           delp(i,j)=MAX(qr*ql/(qr+ql)*(usl-usr),-pold(i,j))
        end do
        do i=d1min,n
           pold(i,j)=pold(i,j)+delp(i,j)
        end do
 
        ! Convergence indicator
        do i=d1min,n 
           uo(i,j)=ABS(delp(i,j)/(pold(i,j)+smallpp))
        end do
        n_new=0
        do i=d1min,n
           if(uo(i,j)>1.d-06)then
              n_new=n_new+1
              ind2(n_new,j)=ind(i,j)
              po  (n_new,j)=pold(i,j)
           end if
        end do
        k=n_new
        do i=d1min,n
           if(uo(i,j)<=1.d-06)then
              n_new=n_new+1
              ind2(n_new,j)=ind (i,j)
              po  (n_new,j)=pold(i,j)
           end if
        end do
        ind (d1min:n,j)=ind2(d1min:n,j)
        pold(d1min:n,j)=po  (d1min:n,j)
        n=k
     end do

     do i=d1min,d1max
        pstar(ind(i,j),j)=pold(i,j)
     end do

     do i=d1min,d1max
        wl(i,j) = sqrt(cl(i,j)*(one+gamma6*(pstar(i,j)-pl(i,j))/pl(i,j)))
        wr(i,j) = sqrt(cr(i,j)*(one+gamma6*(pstar(i,j)-pr(i,j))/pr(i,j)))
     end do
     do i=d1min,d1max
        ustar(i,j) = half*(ul(i,j) + (pl(i,j)-pstar(i,j))/wl(i,j) + &
             &           ur(i,j) - (pr(i,j)-pstar(i,j))/wr(i,j) )
     end do

     do i=d1min,d1max
        sgnm(i,j) = sign(one,ustar(i,j))
     end do

     do i=d1min,d1max
        if(sgnm(i,j)==one)then
           ro(i,j) = rl(i,j)
           uo(i,j) = ul(i,j)
           po(i,j) = pl(i,j)
           wo(i,j) = wl(i,j)
        else
           ro(i,j) = rr(i,j)
           uo(i,j) = ur(i,j)
           po(i,j) = pr(i,j)
           wo(i,j) = wr(i,j)
        end if
     end do

     do i=d1min,d1max
        co(i,j) = max(smallc,sqrt(abs(gamma*po(i,j)/ro(i,j))))
     end do

     do i=d1min,d1max
        rstar(i,j) = ro(i,j)/(one+ro(i,j)*(po(i,j)-pstar(i,j))/wo(i,j)**2)
        rstar(i,j) = max(rstar(i,j),smallr)
     end do
     do i=d1min,d1max
        cstar(i,j) = max(smallc,sqrt(abs(gamma*pstar(i,j)/rstar(i,j))))
     end do
  
     do i=d1min,d1max
        spout (i,j) = co   (i,j)      - sgnm(i,j)*uo   (i,j)
        spin  (i,j) = cstar(i,j)      - sgnm(i,j)*ustar(i,j)
        ushock(i,j) = wo(i,j)/ro(i,j) - sgnm(i,j)*uo   (i,j)
     end do
     do i=d1min,d1max
        if(pstar(i,j)>=po(i,j))then
           spin (i,j) = ushock(i,j)
           spout(i,j) = ushock(i,j)
        end if
     end do
     do i=d1min,d1max
        scr(i,j) = MAX(spout(i,j)-spin(i,j),smallc+ABS(spout(i,j)+spin(i,j)))
     end do
     do i=d1min,d1max
        frac(i,j) = (one + (spout(i,j) + spin(i,j))/scr(i,j))*half
        frac(i,j) = max(zero,min(one,frac(i,j)))
     end do

     do i=d1min,d1max
        qgdnv(i,j,ID) = frac(i,j)*rstar(i,j) + (one - frac(i,j))*ro(i,j)
        qgdnv(i,j,IU) = frac(i,j)*ustar(i,j) + (one - frac(i,j))*uo(i,j)
        qgdnv(i,j,IP) = frac(i,j)*pstar(i,j) + (one - frac(i,j))*po(i,j)
     end do
     do i=d1min,d1max
        if(spout(i,j)<zero)then
           qgdnv(i,j,ID) = ro(i,j)
           qgdnv(i,j,IU) = uo(i,j)
           qgdnv(i,j,IP) = po(i,j)
        end if
     end do
     do i=d1min,d1max
        if(spin(i,j)>zero)then
           qgdnv(i,j,ID) = rstar(i,j)
           qgdnv(i,j,IU) = ustar(i,j)
           qgdnv(i,j,IP) = pstar(i,j)
        end if
     end do

     ! transverse velocity
     do i=d1min,d1max
        if(sgnm(i,j)==one)then
           qgdnv(i,j,IV) = qleft (i,j,IV)
        else
           qgdnv(i,j,IV) = qright(i,j,IV)
        end if
     end do

     ! other passive variables
     if (nvar > 4) then
        do in = 4,nvar
           do i=d1min,d1max
              if(sgnm(i,j)==one)then
                 qgdnv(i,j,in) = qleft (i,j,in)
              else
                 qgdnv(i,j,in) = qright(i,j,in)
              end if
           end do
        end do
     end if
  end do
end subroutine riemann


subroutine cmpflx(d2max)
  use hydro_parameters
  use hydro_const
  use hydro_work_space, only : qgdnv,flux
  implicit none

  ! Dummy argument
  integer(kind=prec_int),intent(in) :: d2max
  ! Local variables
  integer(kind=prec_int) :: j,i,IN,nface,d1min,d1max,d2min
  real(kind=prec_real)   :: entho,etot,ekin

  d1min = lbound(qgdnv,1)
  d1max = ubound(qgdnv,1)
  d2min = lbound(qgdnv,2)
!  d2max = ubound(qgdnv,2)

  entho=one/(gamma-one)

  do j=d2min,d2max
     ! Compute fluxes
     do i=d1min,d1max        
        ! Mass density
        flux(i,j,ID) = qgdnv(i,j,ID)*qgdnv(i,j,IU)
        ! Normal momentum
        flux(i,j,IU) = flux(i,j,ID)*qgdnv(i,j,IU)+qgdnv(i,j,IP)
        ! Transverse momentum 1
        flux(i,j,IV) = flux(i,j,ID)*qgdnv(i,j,IV)
        ! Total energy
        ekin = half*qgdnv(i,j,ID)*(qgdnv(i,j,IU)**2+qgdnv(i,j,IV)**2)
        etot = qgdnv(i,j,IP)*entho + ekin
        flux(i,j,IP) = qgdnv(i,j,IU)*(etot+qgdnv(i,j,IP))
        ! Other advected quantities
        if (nvar>4) then
           do IN = 5, nvar
              flux(i,j,IN) = flux(i,j,ID)*qgdnv(i,j,IN)
           end do
        end if        
     end do
  end do
end subroutine cmpflx

end module hydro_utils
