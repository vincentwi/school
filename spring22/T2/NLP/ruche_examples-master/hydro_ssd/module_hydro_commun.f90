!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! module_hydro_commun.f90 --- 
!!!!
!! module hydro_precision
!! module hydro_commons
!! module hydro_parameters 
!! module hydro_const
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

module hydro_precision
  integer, parameter :: prec_real=kind(1.d0)
  integer, parameter :: prec_int=4
  integer, parameter :: prec_output=4
end module hydro_precision

module hydro_commons
  use hydro_precision
  integer(kind=prec_int) :: imin,imax,jmin,jmax
  integer(kind=prec_int) :: iminbloc,imaxbloc,imaxbloclim,jminbloc,jmaxbloc,jmaxbloclim
  real(kind=prec_real),allocatable,dimension(:,:,:) :: uold
  real(kind=prec_real)   :: t=0._prec_real
  integer(kind=prec_int) :: nstep=0_prec_int
end module hydro_commons

module hydro_parameters
  use hydro_precision
  integer(kind=prec_int) :: nx=2_prec_int
  integer(kind=prec_int) :: ny=2_prec_int
  integer(kind=prec_int) :: idimbloc=1_prec_int
  integer(kind=prec_int) :: jdimbloc=1_prec_int
  integer(kind=prec_int) :: nvar=4_prec_int
  real(kind=prec_real)   :: dx=1.0_prec_real
  real(kind=prec_real)   :: tend=0.0_prec_real
  real(kind=prec_real)   :: gamma=1.4d0
  real(kind=prec_real)   :: courant_factor=0.5d0
  real(kind=prec_real)   :: smallc=1.d-10
  real(kind=prec_real)   :: smallr=1.d-10
  integer(kind=prec_int) :: niter_riemann=10_prec_int
  integer(kind=prec_int) :: iorder=2_prec_int
  real(kind=prec_real)   :: slope_type=1._prec_real
  character(LEN=20)      :: scheme='muscl'
  integer(kind=prec_int) :: boundary_right=1_prec_int
  integer(kind=prec_int) :: boundary_left =1_prec_int
  integer(kind=prec_int) :: boundary_down =1_prec_int
  integer(kind=prec_int) :: boundary_up   =1_prec_int
  integer(kind=prec_int) :: noutput=100_prec_int
  integer(kind=prec_int) :: nstepmax=1000000_prec_int
  logical                :: on_output=.true.
end module hydro_parameters

module hydro_const
  use hydro_precision
  real(kind=prec_real),parameter   :: zero = 0.0_prec_real
  real(kind=prec_real),parameter   :: one = 1.0_prec_real
  real(kind=prec_real),parameter   :: two = 2.0_prec_real
  real(kind=prec_real),parameter   :: three = 3.0_prec_real
  real(kind=prec_real),parameter   :: four = 4.0_prec_real
  real(kind=prec_real),parameter   :: two3rd = 0.6666666666666667d0
  real(kind=prec_real),parameter   :: half = 0.5_prec_real
  real(kind=prec_real),parameter   :: third = 0.33333333333333333d0
  real(kind=prec_real),parameter   :: forth = 0.25_prec_real
  real(kind=prec_real),parameter   :: sixth = 0.16666666666666667d0
  integer(kind=prec_int),parameter :: ID=1_prec_int
  integer(kind=prec_int),parameter :: IU=2_prec_int
  integer(kind=prec_int),parameter :: IV=3_prec_int
  integer(kind=prec_int),parameter :: IP=4_prec_int
end module hydro_const

module hydro_work_space
  use hydro_precision

  ! Work arrays
  ! real(kind=prec_real),dimension(:,:,:),pointer :: u,q,qxm,qxp,dq,qleft,qright,qgdnv,flux
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: c
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: rl,ul,pl,cl,wl
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: rr,ur,pr,cr,wr
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: ro,uo,po,co,wo
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: rstar,ustar,pstar,cstar
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: sgnm,spin,spout,ushock
  ! real(kind=prec_real),dimension(:,:)  ,pointer :: frac,scr,delp,pold
  ! integer(kind=prec_int),dimension(:,:),pointer :: ind,ind2
  real(kind=prec_real),dimension(:,:,:),allocatable :: u,q,qxm,qxp,dq,qleft,qright,qgdnv,flux
  real(kind=prec_real),dimension(:,:)  ,allocatable :: c
  real(kind=prec_real),dimension(:,:)  ,allocatable :: rl,ul,pl,cl,wl
  real(kind=prec_real),dimension(:,:)  ,allocatable :: rr,ur,pr,cr,wr
  real(kind=prec_real),dimension(:,:)  ,allocatable :: ro,uo,po,co,wo
  real(kind=prec_real),dimension(:,:)  ,allocatable :: rstar,ustar,pstar,cstar
  real(kind=prec_real),dimension(:,:)  ,allocatable :: sgnm,spin,spout,ushock
  real(kind=prec_real),dimension(:,:)  ,allocatable :: frac,scr,delp,pold
  integer(kind=prec_int),dimension(:,:),allocatable :: ind,ind2
end module hydro_work_space
