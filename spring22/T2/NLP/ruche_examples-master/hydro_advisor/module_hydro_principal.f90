!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! module_hydro_principal.f90 --- 
!!!!
!! subroutine init_hydro
!! subroutine cmpdt(dt)
!! subroutine godunov(idim,dt)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

module hydro_principal

contains

subroutine init_hydro
  use hydro_commons
  use hydro_const
  use hydro_parameters
  implicit none

  ! Local variables
  integer(kind=prec_int) :: i,j

  imin=1
  imax=nx+4
  jmin=1
  jmax=ny+4
  
  allocate(uold(imin:imax,jmin:jmax,1:nvar))

  jminbloc=1
  jmaxbloc=jminbloc+jdimbloc-1
  
  iminbloc=1
  imaxbloc=iminbloc+idimbloc-1

  ! Initial conditions in grid interior
  ! Warning: conservative variables U = (rho, rhou, rhov, E)

!!$  ! Jet
!!$  do j=jmin+2,jmax-2
!!$     do i=imin+2,imax-2
!!$        uold(i,j,ID)=1.0_prec_real
!!$        uold(i,j,IU)=0.0_prec_real
!!$        uold(i,j,IV)=0.0_prec_real
!!$        uold(i,j,IP)=1.0_prec_real/(gamma-1.0_prec_real)
!!$     end do
!!$  end do

  ! Wind tunnel with point explosion
  do j=jmin+2,jmax-2
     do i=imin+2,imax-2
        uold(i,j,ID)=1.0_prec_real
        uold(i,j,IU)=0.0_prec_real
        uold(i,j,IV)=0.0_prec_real
        uold(i,j,IP)=1.d-5
     end do
  end do
  uold(imin+2,jmin+2,IP)=1._prec_real/dx/dx

!!$  ! 1D Sod test
!!$  do j=jmin+2,jmax-2
!!$     do i=imin+2,imax/2
!!$        uold(i,j,ID)=1.0_prec_real
!!$        uold(i,j,IU)=0.0_prec_real
!!$        uold(i,j,IV)=0.0_prec_real
!!$        uold(i,j,IP)=1.0_prec_real/(gamma-1.0_prec_real)
!!$     end do
!!$     do i=imax/2+1,imax-2
!!$        uold(i,j,ID)=0.125_prec_real
!!$        uold(i,j,IU)=0.0_prec_real
!!$        uold(i,j,IV)=0.0_prec_real
!!$        uold(i,j,IP)=0.1_prec_real/(gamma-1.0_prec_real)
!!$     end do
!!$  end do
end subroutine init_hydro


subroutine cmpdt(dt)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  use hydro_utils
  implicit none

  ! Dummy arguments
  real(kind=prec_real), intent(out) :: dt  
  ! Local variables
  integer(kind=prec_int) :: i,j,jj
  real(kind=prec_real)   :: cournox,cournoy
  ! real(kind=prec_real),  dimension(:,:,:), pointer   :: q
  ! real(kind=prec_real),  dimension(:,:)  , pointer   :: e,c
  real(kind=prec_real),  dimension(:,:,:), allocatable   :: q
  real(kind=prec_real),  dimension(:,:)  , allocatable   :: e,c
  real(kind=prec_real),  dimension(:),     allocatable   :: eken   

  ! compute time step on grid interior
  cournox = zero
  cournoy = zero

  allocate(q(1:nx,jminbloc:jmaxbloc,1:IP))
  allocate(e(1:nx,jminbloc:jmaxbloc),c(1:nx,jminbloc:jmaxbloc))
  allocate(eken(jminbloc:jmaxbloc))

  do j=jmin+2,jmax-2,jdimbloc
     jmaxbloclim=min(jdimbloc,jmax-j-1)
     do jj=jminbloc,jmaxbloclim
        do i=1,nx
           q(i,jj,ID) = max(uold(i+2,j+jj-1,ID),smallr)
           q(i,jj,IU) = uold(i+2,j+jj-1,IU)/q(i,jj,ID)
           q(i,jj,IV) = uold(i+2,j+jj-1,IV)/q(i,jj,ID)
           eken(jj) = half*(q(i,jj,IU)**2+q(i,jj,IV)**2)
           q(i,jj,IP) = uold(i+2,j+jj-1,IP)/q(i,jj,ID) - eken(jj)
           e(i,jj)=q(i,jj,IP)
        end do
     end do
     call eos(q,e,c,jmaxbloclim)

     cournox=max(cournox,maxval(c(1:nx,jminbloc:jmaxbloclim)+abs(q(1:nx,jminbloc:jmaxbloclim,IU))))
     cournoy=max(cournoy,maxval(c(1:nx,jminbloc:jmaxbloclim)+abs(q(1:nx,jminbloc:jmaxbloclim,IV))))

  end do

  deallocate(q,e,c,eken)

  dt = courant_factor*dx/max(cournox,cournoy,smallc)
end subroutine cmpdt


subroutine godunov(idim,dt)
  use hydro_commons
  use hydro_const
  use hydro_parameters
  use hydro_utils
  use hydro_work_space
  implicit none

  ! Dummy arguments
  integer(kind=prec_int), intent(in) :: idim
  real(kind=prec_real),   intent(in) :: dt
  ! Local variables
  integer(kind=prec_int) :: i,ii,j,jj,in
  real(kind=prec_real)   :: dtdx
  
  ! constant
  dtdx=dt/dx

  ! Update boundary conditions
  call make_boundary(idim)

  if (idim==1)then
     ! Allocate work space for 1D or 2D sweeps
     call allocate_work_space(imin,imax,jminbloc,jmaxbloc)
 
     do j=jmin+2,jmax-2,jdimbloc
        ! Gather conservative variables
        jmaxbloclim=min(jdimbloc,jmax-j-1)
        do jj=jminbloc,jmaxbloclim
           do i=imin,imax
              u(i,jj,ID)=uold(i,j+jj-1,ID)
              u(i,jj,IU)=uold(i,j+jj-1,IU)
              u(i,jj,IV)=uold(i,j+jj-1,IV)
              u(i,jj,IP)=uold(i,j+jj-1,IP)
           end do
        end do
        if(nvar>4)then
           do in = 5,nvar
              do jj=jminbloc,jmaxbloclim
                 u(imin:imax,jj,in)=uold(imin:imax,j+jj-1,in)
              end do
           end do
        end if

        ! Convert to primitive variables
        call constoprim(jmaxbloclim)

        ! Characteristic tracing
        call trace(dtdx,jmaxbloclim)

        do in=1,nvar
           do jj=jminbloc,jmaxbloclim
              do i=imin,imax-3
                 qleft (i,jj,in)=qxm(i+1,jj,in)
                 qright(i,jj,in)=qxp(i+2,jj,in)
              end do
           end do
        end do

        ! Solve Riemann problem at interfaces
        call riemann(jmaxbloclim)

        ! Compute fluxes
        call cmpflx(jmaxbloclim)

        ! Update conservative variables 
        do jj=jminbloc,jmaxbloclim
           do i=imin+2,imax-2
              uold(i,j+jj-1,ID)=u(i,jj,ID)+(flux(i-2,jj,ID)-flux(i-1,jj,ID))*dtdx
              uold(i,j+jj-1,IU)=u(i,jj,IU)+(flux(i-2,jj,IU)-flux(i-1,jj,IU))*dtdx
              uold(i,j+jj-1,IV)=u(i,jj,IV)+(flux(i-2,jj,IV)-flux(i-1,jj,IV))*dtdx
              uold(i,j+jj-1,IP)=u(i,jj,IP)+(flux(i-2,jj,IP)-flux(i-1,jj,IP))*dtdx
           end do
        end do
        if(nvar>4)then
           do in = 5,nvar
              do jj=jminbloc,jmaxbloclim
                 uold(imin+2:imax-2,j+jj-1,in)=u(imin+2:imax-2,jj,in)+ &
                      (flux(imin:imax-4,jj,in)-flux(imin+1:imax-3,jj,in))*dtdx
              end do
           end do
        end if
     end do

     ! Deallocate work space
     call deallocate_work_space

 else

     ! Allocate work space for 1D or 2D sweeps
     call allocate_work_space(jmin,jmax,iminbloc,imaxbloc)
  
     do i=imin+2,imax-2,idimbloc
        ! Gather conservative variables
        imaxbloclim=min(idimbloc,imax-i-1)
        do ii=iminbloc,imaxbloclim
           do j=jmin,jmax
              u(j,ii,ID)=uold(i+ii-1,j,ID)
              u(j,ii,IU)=uold(i+ii-1,j,IV)
              u(j,ii,IV)=uold(i+ii-1,j,IU)
              u(j,ii,IP)=uold(i+ii-1,j,IP)
           enddo
        enddo
        if(nvar>4)then
           do in = 5,nvar
              do ii=iminbloc,imaxbloclim
                 u(jmin:jmax,ii,in)=uold(i+ii-1,jmin:jmax,in)
              end do
           end do
        end if

        ! Convert to primitive variables
        call constoprim(imaxbloclim)

        ! Characteristic tracing
        call trace(dtdx,imaxbloclim)

        do in=1,nvar
           do ii=iminbloc,imaxbloclim
              do j=jmin,jmax-3
                 qleft (j,ii,in)=qxm(j+1,ii,in)
                 qright(j,ii,in)=qxp(j+2,ii,in)
              end do
           enddo
        enddo

        ! Solve Riemann problem at interfaces
        call riemann(imaxbloclim)

        ! Compute fluxes
        call cmpflx(imaxbloclim)

        do ii=iminbloc,imaxbloclim
           do j=jmin+2,jmax-2
              uold(i+ii-1,j,ID)=u(j,ii,ID)+(flux(j-2,ii,ID)-flux(j-1,ii,ID))*dtdx
              uold(i+ii-1,j,IU)=u(j,ii,IV)+(flux(j-2,ii,IV)-flux(j-1,ii,IV))*dtdx
              uold(i+ii-1,j,IV)=u(j,ii,IU)+(flux(j-2,ii,IU)-flux(j-1,ii,IU))*dtdx
              uold(i+ii-1,j,IP)=u(j,ii,IP)+(flux(j-2,ii,IP)-flux(j-1,ii,IP))*dtdx
           end do
        end do
        if(nvar>4)then
           do in = 5,nvar
              do ii=iminbloc,imaxbloclim
                 uold(i+ii-1,jmin+2:jmax-2,in)=u(jmin+2:jmax-2,ii,in)+ &
                      (flux(jmin:jmax-4,ii,in)-flux(jmin+1:jmax-3,ii,in))*dtdx
              end do
           end do
        end if
     end do

     call deallocate_work_space

  end if

contains

  subroutine allocate_work_space(d1min,d1max,d2min,d2max)
    implicit none

    ! Dummy arguments
    integer(kind=prec_int), intent(in) :: d1min, d1max, d2min, d2max

    allocate(u  (d1min:d1max,d2min:d2max,1:nvar))
    allocate(q  (d1min:d1max,d2min:d2max,1:nvar))
    allocate(dq (d1min:d1max,d2min:d2max,1:nvar))
    allocate(qxm(d1min:d1max,d2min:d2max,1:nvar))
    allocate(qxp(d1min:d1max,d2min:d2max,1:nvar))
    allocate(c  (d1min:d1max,d2min:d2max))
    allocate(qleft (d1min:d1max-3,d2min:d2max,1:nvar))
    allocate(qright(d1min:d1max-3,d2min:d2max,1:nvar))
    allocate(qgdnv (d1min:d1max-3,d2min:d2max,1:nvar))
    allocate(flux  (d1min:d1max-3,d2min:d2max,1:nvar))
    allocate(rl    (d1min:d1max-3,d2min:d2max), ul   (d1min:d1max-3,d2min:d2max))
    allocate(pl    (d1min:d1max-3,d2min:d2max), cl    (d1min:d1max-3,d2min:d2max))
    allocate(rr    (d1min:d1max-3,d2min:d2max), ur   (d1min:d1max-3,d2min:d2max))
    allocate(pr    (d1min:d1max-3,d2min:d2max), cr    (d1min:d1max-3,d2min:d2max))
    allocate(ro    (d1min:d1max-3,d2min:d2max), uo   (d1min:d1max-3,d2min:d2max))
    allocate(po    (d1min:d1max-3,d2min:d2max), co    (d1min:d1max-3,d2min:d2max))
    allocate(rstar (d1min:d1max-3,d2min:d2max), ustar(d1min:d1max-3,d2min:d2max))
    allocate(pstar (d1min:d1max-3,d2min:d2max), cstar (d1min:d1max-3,d2min:d2max))
    allocate(wl    (d1min:d1max-3,d2min:d2max), wr   (d1min:d1max-3,d2min:d2max))
    allocate(wo    (d1min:d1max-3,d2min:d2max))
    allocate(sgnm  (d1min:d1max-3,d2min:d2max), spin (d1min:d1max-3,d2min:d2max))
    allocate(spout (d1min:d1max-3,d2min:d2max), ushock(d1min:d1max-3,d2min:d2max))
    allocate(frac  (d1min:d1max-3,d2min:d2max), scr  (d1min:d1max-3,d2min:d2max))
    allocate(delp  (d1min:d1max-3,d2min:d2max), pold  (d1min:d1max-3,d2min:d2max))
    allocate(ind   (d1min:d1max-3,d2min:d2max), ind2 (d1min:d1max-3,d2min:d2max))
  end subroutine allocate_work_space

  subroutine deallocate_work_space
    deallocate(u,q,dq,qxm,qxp,c,qleft,qright,qgdnv,flux)
    deallocate(rl,ul,pl,cl)
    deallocate(rr,ur,pr,cr)  
    deallocate(ro,uo,po,co)  
    deallocate(rstar,ustar,pstar,cstar)
    deallocate(wl,wr,wo)
    deallocate(sgnm,spin,spout,ushock)
    deallocate(frac,scr,delp,pold)
    deallocate(ind,ind2)    
  end subroutine deallocate_work_space

 end subroutine godunov

end module hydro_principal
