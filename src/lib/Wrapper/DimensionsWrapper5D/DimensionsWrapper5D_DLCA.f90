!-----------------------------------------------------------------
! FPL (Fortran Parameter List)
! Copyright (c) 2015 Santiago Badia, Alberto F. Martín, 
! Javier Principe and Víctor Sande.
! All rights reserved.
!
! This library is free software; you can redistribute it and/or
! modify it under the terms of the GNU Lesser General Public
! License as published by the Free Software Foundation; either
! version 3.0 of the License, or (at your option) any later version.
!
! This library is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this library.
!-----------------------------------------------------------------

module DimensionsWrapper5D_DLCA

USE DimensionsWrapper5D
USE IR_Precision, only: I4P, str, byte_size
USE ErrorMessages

implicit none
private

    type, extends(DimensionsWrapper5D_t) :: DimensionsWrapper5D_DLCA_t
        character(len=:), allocatable :: Value(:,:,:,:,:)
    contains
    private
        procedure, public :: Set            => DimensionsWrapper5D_DLCA_Set
        procedure, public :: Get            => DimensionsWrapper5D_DLCA_Get
        procedure, public :: GetShape       => DimensionsWrapper5D_DLCA_GetShape
        procedure, public :: GetPointer     => DimensionsWrapper5D_DLCA_GetPointer
        procedure, public :: GetPolymorphic => DimensionsWrapper5D_DLCA_GetPolymorphic
        procedure, public :: DataSizeInBytes=> DimensionsWrapper5D_DLCA_DataSizeInBytes
        procedure, public :: isOfDataType   => DimensionsWrapper5D_DLCA_isOfDataType
        procedure, public :: Print          => DimensionsWrapper5D_DLCA_Print
        procedure, public :: Free           => DimensionsWrapper5D_DLCA_Free
        final             ::                   DimensionsWrapper5D_DLCA_Final
    end type           

public :: DimensionsWrapper5D_DLCA_t

contains


    subroutine DimensionsWrapper5D_DLCA_Final(this) 
    !-----------------------------------------------------------------
    !< Final procedure of DimensionsWrapper5D
    !-----------------------------------------------------------------
        type(DimensionsWrapper5D_DLCA_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        call this%Free()
    end subroutine


    subroutine DimensionsWrapper5D_DLCA_Set(this, Value) 
    !-----------------------------------------------------------------
    !< Set DLCA Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(INOUT) :: this
        class(*),                          intent(IN)    :: Value(:,:,:,:,:)
        integer                                          :: err
    !-----------------------------------------------------------------
#ifdef __GFORTRAN__ 
        call msg%Warn(txt='Setting value: Array of deferred length allocatable arrays not supported in Gfortran)',&
                      file=__FILE__, line=__LINE__ )
#else   
        select type (Value)
            type is (character(len=*))
                allocate(character(len=len(Value))::               &
                                    this%Value(size(Value,dim=1),  &
                                    size(Value,dim=2),             &
                                    size(Value,dim=3),             &
                                    size(Value,dim=4),             &
                                    size(Value,dim=5)),            &
                                    stat=err)
                this%Value = Value
                if(err/=0) &
                    call msg%Error( txt='Setting Value: Allocation error ('//&
                                    str(no_sign=.true.,n=err)//')', &
                                    file=__FILE__, line=__LINE__ )
            class Default
                call msg%Warn( txt='Setting value: Expected data type (character(*))', &
                               file=__FILE__, line=__LINE__ )

        end select
#endif
    end subroutine


    subroutine DimensionsWrapper5D_DLCA_Get(this, Value) 
    !-----------------------------------------------------------------
    !< Get deferred length character array Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(IN)  :: this
        class(*),                          intent(OUT) :: Value(:,:,:,:,:)
        integer(I4P), allocatable                     :: ValueShape(:)
    !-----------------------------------------------------------------
        select type (Value)
            type is (character(len=*))
                call this%GetShape(ValueShape)
                if(all(ValueShape == shape(Value))) then
                    Value = this%Value
                else
                    call msg%Warn(txt='Getting value: Wrong shape ('//&
                                  str(no_sign=.true.,n=ValueShape)//'/='//&
                                  str(no_sign=.true.,n=shape(Value))//')',&
                                  file=__FILE__, line=__LINE__ )
                endif
            class Default
                call msg%Warn(txt='Getting value: Expected data type (DLCA)',&
                              file=__FILE__, line=__LINE__ )
        end select
    end subroutine


    subroutine DimensionsWrapper5D_DLCA_GetShape(this, ValueShape)
    !-----------------------------------------------------------------
    !< Get Wrapper Value Shape
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(IN)    :: this
        integer(I4P), allocatable,         intent(INOUT) :: ValueShape(:)
    !-----------------------------------------------------------------
        if(allocated(ValueShape)) deallocate(ValueShape)
		allocate(ValueShape(this%GetDimensions()))
        ValueShape = shape(this%Value, kind=I4P)
    end subroutine


    function DimensionsWrapper5D_DLCA_GetPointer(this) result(Value) 
    !-----------------------------------------------------------------
    !< Get Unlimited Polymorphic pointer to Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), target, intent(IN)  :: this
        class(*), pointer                                      :: Value(:,:,:,:,:)
    !-----------------------------------------------------------------
        Value => this%Value
    end function


    subroutine DimensionsWrapper5D_DLCA_GetPolymorphic(this, Value) 
    !-----------------------------------------------------------------
    !< Get Unlimited Polymorphic Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(IN)  :: this
        class(*), allocatable,             intent(OUT) :: Value(:,:,:,:,:)
    !-----------------------------------------------------------------
!        allocate(Value(size(this%Value,dim=1),  &
!                       size(this%Value,dim=2),  &
!                       size(this%Value,dim=3),  &
!                       size(this%Value,dim=4),  &
!                       size(this%Value,dim=5)), &
!                       source=this%Value)
    end subroutine


    subroutine DimensionsWrapper5D_DLCA_Free(this) 
    !-----------------------------------------------------------------
    !< Free a DimensionsWrapper5D
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(INOUT) :: this
        integer                                         :: err
    !-----------------------------------------------------------------
        if(allocated(this%Value)) then
            deallocate(this%Value, stat=err)
            if(err/=0) call msg%Error(txt='Freeing Value: Deallocation error ('// &
                                      str(no_sign=.true.,n=err)//')',             &
                                      file=__FILE__, line=__LINE__ )
        endif
    end subroutine


    function DimensionsWrapper5D_DLCA_DataSizeInBytes(this) result(DataSizeInBytes)
    !-----------------------------------------------------------------
    !< Return the size of the stored data in bytes
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(IN) :: this            !< Dimensions wrapper 5D
        integer(I4P)                                  :: DataSizeInBytes !< Size of lthe stored data in bytes
    !-----------------------------------------------------------------
        DataSizeInBytes = 0
        if(allocated(this%value)) DataSizeInBytes = byte_size(this%value(1,1,1,1,1))*size(this%value)
    end function DimensionsWrapper5D_DLCA_DataSizeInBytes


    function DimensionsWrapper5D_DLCA_isOfDataType(this, Mold) result(isOfDataType)
    !-----------------------------------------------------------------
    !< Check if Mold and Value are of the same datatype 
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t), intent(IN) :: this         !< Dimensions wrapper 5D
        class(*),                          intent(IN) :: Mold         !< Mold for data type comparison
        logical                                  :: isOfDataType      !< Boolean flag to check if Value is of the same data type as Mold
    !-----------------------------------------------------------------
        isOfDataType = .false.
        select type (Mold)
            type is (character(len=*))
                isOfDataType = .true.
        end select
    end function DimensionsWrapper5D_DLCA_isOfDataType


    subroutine DimensionsWrapper5D_DLCA_Print(this, unit, prefix, iostat, iomsg)
    !-----------------------------------------------------------------
    !< Print Wrapper
    !-----------------------------------------------------------------
        class(DimensionsWrapper5D_DLCA_t),intent(IN)  :: this         !< DimensionsWrapper
        integer(I4P),                     intent(IN)  :: unit         !< Logic unit.
        character(*), optional,           intent(IN)  :: prefix       !< Prefixing string.
        integer(I4P), optional,           intent(OUT) :: iostat       !< IO error.
        character(*), optional,           intent(OUT) :: iomsg        !< IO error message.
        character(len=:), allocatable                 :: prefd        !< Prefixing string.
        integer(I4P)                                  :: iostatd      !< IO error.
        character(500)                                :: iomsgd       !< Temporary variable for IO error message.
    !-----------------------------------------------------------------
        prefd = '' ; if (present(prefix)) prefd = prefix
        write(unit=unit,fmt='(A,$)',iostat=iostatd,iomsg=iomsgd) prefd//' Data Type = DLCA'//&
                        ', Dimensions = '//trim(str(no_sign=.true., n=this%GetDimensions()))//&
                        ', Bytes = '//trim(str(no_sign=.true., n=this%DataSizeInBytes()))//&
                        ', Value = '
        write(unit=unit,fmt=*,iostat=iostatd,iomsg=iomsgd) this%Value
        if (present(iostat)) iostat = iostatd
        if (present(iomsg))  iomsg  = iomsgd
    end subroutine DimensionsWrapper5D_DLCA_Print

end module DimensionsWrapper5D_DLCA
