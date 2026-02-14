import React from 'react';
import { NeoCard, NeoInput, NeoTextarea, NeoButton, NeoAvatar } from '../components/UI';

export const Settings: React.FC = () => {
  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto">
      <header className="mb-8">
        <h1 className="text-4xl md:text-5xl font-black mb-2">Cài đặt Tài khoản</h1>
        <div className="h-1 w-full bg-black"></div>
      </header>

      <div className="space-y-8">
        {/* Profile Info */}
        <NeoCard>
          <h2 className="text-2xl font-bold mb-2">Thông tin cá nhân</h2>
          <p className="font-mono text-sm text-gray-600 mb-6">Cập nhật ảnh đại diện và thông tin cá nhân của bạn.</p>

          <div className="flex flex-col md:flex-row gap-6 items-center mb-8">
            <NeoAvatar src="https://picsum.photos/seed/settings/200" alt="Avatar" size="xl" className="shadow-hard" />
            <NeoButton variant="secondary">Thay đổi ảnh</NeoButton>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <NeoInput 
              label="Tên hiển thị" 
              placeholder="Tên của bạn" 
              defaultValue="Username" 
              helperText="Tên này sẽ hiển thị trên hồ sơ của bạn."
            />
            <NeoInput 
              label="Tên người dùng" 
              placeholder="@username" 
              defaultValue="@username" 
              helperText="URL hồ sơ của bạn: website.com/@username"
            />
          </div>

          <NeoTextarea 
            label="Tiểu sử" 
            placeholder="Kể một chút về bạn..." 
            rows={4}
          />
        </NeoCard>

        {/* Security */}
        <NeoCard>
          <h2 className="text-2xl font-bold mb-2">Bảo mật Tài khoản</h2>
          <p className="font-mono text-sm text-gray-600 mb-6">Thay đổi mật khẩu và quản lý bảo mật tài khoản.</p>

          <div className="space-y-6">
            <NeoInput label="Mật khẩu hiện tại" type="password" />
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <NeoInput label="Mật khẩu mới" type="password" />
              <NeoInput label="Xác nhận mật khẩu mới" type="password" />
            </div>
          </div>
        </NeoCard>

        {/* Actions */}
        <div className="flex flex-col-reverse sm:flex-row justify-between gap-4 pt-6 border-t-2 border-black">
          <NeoButton variant="danger" className="text-white bg-red-600">Xóa Tài khoản</NeoButton>
          <div className="flex gap-4">
             <NeoButton variant="secondary">Hủy</NeoButton>
             <NeoButton variant="primary">Lưu Thay Đổi</NeoButton>
          </div>
        </div>
      </div>
    </div>
  );
};
