!!!
!!! 2020/08/09, Chun-Yeh Lu, NTU, window120909120909@gmail.com
!!!

!!! subroutine list:
!!!     find_level_1(nx, ny, nz, zdata, level, out)
!!!         find the index of level 
!!!     find_level_n(nx, ny, nz, zdata, nlev, levels, out)
!!!         find the index of levels
!!!     interpz3d_1(nx, ny, nz, var, zdata, level, lev_idx, var_interp)
!!!         interpolating 3d variable on a vertical level
!!!     interpz3d_n(nx, ny, nz, var, zdata, nlev, levels, lev_idx, var_interp)
!!!         interpolating 3d variable on multiple vertical levels

!!! NOTE:
!!! When `find_level_1` and `find_level_n` used in python directly, the result should
!!! minus 1 because python index is start from 0 and fortran is from 1.


subroutine find_level_1(nx, ny, nz, zdata, level, out)
    !! find levels, where level is integer
    !!
    !! intput
    !! ------
    !! nx, ny, nz : 
    !!     spatial dimension
    !! zdata(nx, ny, nz) : 
    !!     vertical coordinate, e.g pressure
    !!     `zdata` must be descent order, that is zdata(i, j, z) < zdata(i, j, z+1).
    !! levels : 
    !!     interpolating level
    !!
    !! output
    !! ------
    !! out(nx, ny) : 
    !!     the level information. For example, if out(i, j) = 5, it means 
    !!     that zdata(i, j, 5) <= level < zdata(i, j, 6)
    
    implicit none
    
    ! arguments
    integer, intent(in) :: nx, ny, nz
    real(kind=8), dimension(nx, ny, nz), intent(in) :: zdata
    real(kind=8), intent(in) :: level
    integer, dimension(nx, ny), intent(out) :: out
    
    ! local variables
    integer :: i, j, k
    
    do i = 1, nx
        do j = 1, ny  
            k = 1
            do while ((zdata(i,j,k) >= level) .and. (k <= nz))
                k = k + 1
            end do    
            out(i,j) = k - 1
        end do
    end do
    
    return 
end subroutine find_level_1


subroutine find_level_n(nx, ny, nz, zdata, nlev, levels, out)
    !! find levels.
    !! It is similar to `find_level_1`, but is multiple levels instead
    !! of one level.
    !!
    !! intput
    !! ------
    !! nx, ny, nz : 
    !!     spatial dimension
    !! zdata(nx, ny, nz) : 
    !!     vertical coordinate, e.g pressure
    !!     `zdata` must be descent order, that is zdata(i, j, z) < zdata(i, j, z+1).
    !! nlev : 
    !!     number of interpolating levels
    !! levels(nlev) : 
    !!     interpolating levels
    !!
    !! output
    !! ------
    !! out(nx, ny, nlev) : 
    !!     the level information. For example, if out(i, j, ilev) = 5, 
    !!     it means that zdata(i, j, 5) <= levels(ilev) < zdata(i, j, 6)
    
    implicit none
    
    !f2py threadsafe
    
    ! arguments
    integer, intent(in) :: nx, ny, nz
    real(kind=8), dimension(nx, ny, nz), intent(in) :: zdata
    integer, intent(in) :: nlev
    real(kind=8), dimension(nlev), intent(in) :: levels
    integer, dimension(nx, ny, nlev), intent(out) :: out
    
    ! local variables
    integer :: ilev
    
    
    !$omp parallel do
    do ilev = 1, nlev
        call find_level_1(nx, ny, nz, zdata, levels(ilev), out(:,:,ilev))
    end do
    !$omp end parallel do
    
    return
end subroutine find_level_n


subroutine interpz3d_1(nx, ny, nz, var, zdata, level, lev_idx, var_interp)
    implicit none
    
    ! arguments
    integer, intent(in) :: nx, ny, nz
    real(kind=8), dimension(nx, ny, nz), intent(in) :: var, zdata
    real(kind=8), intent(in) :: level
    integer, dimension(nx, ny), intent(in) :: lev_idx
    real(kind=8), dimension(nx, ny), intent(out) :: var_interp
    
    ! local variables
    integer :: i, j, idx
    real(kind=8) :: w1, w2
    
    do i = 1, nx
        do j = 1, ny
            idx = lev_idx(i,j)
            
            ! if 可以拿掉?
            !if ((idx .ne. 0) .and. (idx .ne. nz)) then
                w1 = (level - zdata(i,j,idx+1)) / (zdata(i,j,idx) - zdata(i,j,idx+1))
                w2 = 1 - w1
                var_interp(i,j) = w1 * var(i,j,idx) + w2 * var(i,j,idx+1)
            !end if
            
        end do
    end do
    
end subroutine interpz3d_1
    
    
subroutine interpz3d_n(nx, ny, nz, var, zdata, nlev, levels, lev_idx, var_interp)
    implicit none
    !f2py threadsafe
    
    ! arguments
    integer, intent(in) :: nx, ny, nz, nlev
    real(kind=8), dimension(nx, ny, nz), intent(in) :: var, zdata
    real(kind=8), dimension(nlev), intent(in) :: levels
    integer, dimension(nx, ny, nlev), intent(in) :: lev_idx
    real(kind=8), dimension(nx, ny, nlev), intent(out) :: var_interp
    
    ! local variables
    integer :: i, j, k, ilev
    
    !$omp parallel do
    do ilev = 1, nlev
        call interpz3d_1(nx, ny, nz, var, zdata, levels(ilev), lev_idx(:,:,ilev), var_interp(:,:,ilev))
    end do
    !$omp end parallel do
    
    return
end subroutine interpz3d_n
    